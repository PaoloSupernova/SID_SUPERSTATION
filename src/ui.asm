// ============================================================================
// SID SUPERSTATION - User Interface
// ============================================================================
// PETSCII-based user interface rendering
// ============================================================================

// ============================================================================
// UI State Variables
// ============================================================================
.label ui_current_page      = $0400     // Current UI page (0=synth, 1=seq, etc.)
.label ui_cursor_x          = $0401     // Cursor X position
.label ui_cursor_y          = $0402     // Cursor Y position
.label ui_selected_voice    = $0403     // Selected voice for editing (0-2)
.label ui_selected_param    = $0404     // Selected parameter
.label ui_edit_mode         = $0405     // Edit mode flag
.label ui_dirty_flag        = $0406     // Screen needs refresh

// UI page constants
.const PAGE_SYNTH           = 0
.const PAGE_SEQUENCER       = 1
.const PAGE_FILTER          = 2
.const PAGE_LFO             = 3
.const PAGE_ARP             = 4
.const PAGE_SAVE_LOAD       = 5

// ============================================================================
// Initialize UI
// ============================================================================
ui_init:
    // Clear screen
    jsr ui_clear_screen
    
    // Set colors
    lda #COL_LIGHT_BLUE
    sta VIC_BORDER
    lda #COL_BLUE
    sta VIC_BACKGROUND
    
    // Initialize UI state
    lda #PAGE_SYNTH
    sta ui_current_page
    lda #$00
    sta ui_cursor_x
    sta ui_cursor_y
    sta ui_selected_voice
    sta ui_edit_mode
    
    // Force initial draw
    lda #$01
    sta ui_dirty_flag
    
    rts

// ============================================================================
// Clear Screen
// ============================================================================
ui_clear_screen:
    lda #CHR_SPACE
    ldx #$00
clear_screen_loop:
    sta SCREEN_RAM,x
    sta SCREEN_RAM+$100,x
    sta SCREEN_RAM+$200,x
    sta SCREEN_RAM+$300,x
    inx
    bne clear_screen_loop
    
    // Set default color (white)
    lda #COL_WHITE
    ldx #$00
clear_color_loop:
    sta COLOR_RAM,x
    sta COLOR_RAM+$100,x
    sta COLOR_RAM+$200,x
    sta COLOR_RAM+$300,x
    inx
    bne clear_color_loop
    
    rts

// ============================================================================
// Update UI
// ============================================================================
// Main UI update routine - called from main loop
// Checks if screen needs refresh and updates accordingly
// ============================================================================
ui_update:
    // Check if screen needs refresh
    lda ui_dirty_flag
    beq ui_update_done
    
    // Clear dirty flag
    lda #$00
    sta ui_dirty_flag
    
    // Draw appropriate page
    lda ui_current_page
    cmp #PAGE_SYNTH
    beq draw_synth_page
    cmp #PAGE_SEQUENCER
    beq draw_sequencer_page
    cmp #PAGE_FILTER
    beq draw_filter_page
    cmp #PAGE_LFO
    beq draw_lfo_page
    cmp #PAGE_ARP
    beq draw_arp_page
    cmp #PAGE_SAVE_LOAD
    beq draw_save_load_page
    
ui_update_done:
    rts

// ============================================================================
// Draw Synth Page
// ============================================================================
draw_synth_page:
    jsr ui_clear_screen
    
    // Draw title bar
    ldx #$00
    ldy #$00
    jsr ui_set_cursor
    ldx #<str_title
    ldy #>str_title
    jsr ui_print_string
    
    // Draw patch number
    ldx #$23
    ldy #$00
    jsr ui_set_cursor
    ldx #<str_patch_label
    ldy #>str_patch_label
    jsr ui_print_string
    
    lda ZP_CURRENT_PATCH
    jsr ui_print_hex_byte
    
    // Draw horizontal line
    ldx #$00
    ldy #$01
    jsr ui_set_cursor
    ldx #40
    lda #$40                // Horizontal line character
draw_hline_loop:
    jsr ui_print_char
    dex
    bne draw_hline_loop
    
    // Draw oscillator section
    ldx #$01
    ldy #$02
    jsr ui_set_cursor
    ldx #<str_osc_section
    ldy #>str_osc_section
    jsr ui_print_string
    
    // Draw voice 1 waveform
    ldx #$06
    ldy #$02
    jsr ui_set_cursor
    lda voice_waveform+0
    jsr ui_print_waveform
    
    // Draw voice 2 waveform
    ldx #$11
    ldy #$02
    jsr ui_set_cursor
    lda voice_waveform+1
    jsr ui_print_waveform
    
    // Draw voice 3 waveform
    ldx #$1C
    ldy #$02
    jsr ui_set_cursor
    lda voice_waveform+2
    jsr ui_print_waveform
    
    // Draw ADSR section
    ldx #$01
    ldy #$04
    jsr ui_set_cursor
    ldx #<str_adsr_section
    ldy #>str_adsr_section
    jsr ui_print_string
    
    // Draw filter section
    ldx #$01
    ldy #$06
    jsr ui_set_cursor
    ldx #<str_filter_section
    ldy #>str_filter_section
    jsr ui_print_string
    
    // Draw LFO section
    ldx #$01
    ldy #$09
    jsr ui_set_cursor
    ldx #<str_lfo_section
    ldy #>str_lfo_section
    jsr ui_print_string
    
    // Draw function key help
    ldx #$01
    ldy #$17
    jsr ui_set_cursor
    ldx #<str_fkeys_1
    ldy #>str_fkeys_1
    jsr ui_print_string
    
    ldx #$01
    ldy #$18
    jsr ui_set_cursor
    ldx #<str_fkeys_2
    ldy #>str_fkeys_2
    jsr ui_print_string
    
    rts

// ============================================================================
// Draw Sequencer Page
// ============================================================================
draw_sequencer_page:
    jsr ui_clear_screen
    
    // Draw title
    ldx #$00
    ldy #$00
    jsr ui_set_cursor
    ldx #<str_seq_title
    ldy #>str_seq_title
    jsr ui_print_string
    
    // Draw pattern number
    ldx #$14
    ldy #$00
    jsr ui_set_cursor
    ldx #<str_pat_label
    ldy #>str_pat_label
    jsr ui_print_string
    
    lda seq_current_pattern
    jsr ui_print_hex_byte
    
    // Draw BPM
    ldx #$1A
    ldy #$00
    jsr ui_set_cursor
    ldx #<str_bpm_label
    ldy #>str_bpm_label
    jsr ui_print_string
    
    lda seq_tempo
    jsr ui_print_decimal
    
    // Draw step headers
    ldx #$01
    ldy #$02
    jsr ui_set_cursor
    ldx #<str_step_header
    ldy #>str_step_header
    jsr ui_print_string
    
    // Draw step numbers (01-08)
    ldx #$07
    ldy #$02
    jsr ui_set_cursor
    lda #$01
draw_step_nums1:
    pha
    jsr ui_print_hex_byte
    lda #CHR_SPACE
    jsr ui_print_char
    jsr ui_print_char
    pla
    clc
    adc #$01
    cmp #$09
    bne draw_step_nums1
    
    // Draw voice data (simplified - would show actual notes)
    ldx #$01
    ldy #$03
    jsr ui_set_cursor
    ldx #<str_v1_label
    ldy #>str_v1_label
    jsr ui_print_string
    
    // Draw transport controls
    ldx #$01
    ldy #$16
    jsr ui_set_cursor
    ldx #<str_transport
    ldy #>str_transport
    jsr ui_print_string
    
    rts

// ============================================================================
// Draw Filter Page
// ============================================================================
draw_filter_page:
    jsr ui_clear_screen
    
    ldx #$01
    ldy #$01
    jsr ui_set_cursor
    ldx #<str_filter_page
    ldy #>str_filter_page
    jsr ui_print_string
    
    // TODO: Draw filter parameters
    
    rts

// ============================================================================
// Draw LFO Page
// ============================================================================
draw_lfo_page:
    jsr ui_clear_screen
    
    ldx #$01
    ldy #$01
    jsr ui_set_cursor
    ldx #<str_lfo_page
    ldy #>str_lfo_page
    jsr ui_print_string
    
    // TODO: Draw LFO parameters
    
    rts

// ============================================================================
// Draw Arpeggiator Page
// ============================================================================
draw_arp_page:
    jsr ui_clear_screen
    
    ldx #$01
    ldy #$01
    jsr ui_set_cursor
    ldx #<str_arp_page
    ldy #>str_arp_page
    jsr ui_print_string
    
    // TODO: Draw arpeggiator parameters
    
    rts

// ============================================================================
// Draw Save/Load Page
// ============================================================================
draw_save_load_page:
    jsr ui_clear_screen
    
    ldx #$01
    ldy #$01
    jsr ui_set_cursor
    ldx #<str_saveload_page
    ldy #>str_saveload_page
    jsr ui_print_string
    
    // TODO: Draw save/load interface
    
    rts

// ============================================================================
// Set Cursor Position
// ============================================================================
// Inputs: X = column (0-39), Y = row (0-24)
// Outputs: ZP_PTR1 points to screen position
// Modifies: A, ZP_PTR1
// ============================================================================
ui_set_cursor:
    stx ui_cursor_x
    sty ui_cursor_y
    
    // Calculate screen address
    // Address = SCREEN_RAM + (row * 40) + column
    
    // Multiply row by 40
    lda #$00
    sta ZP_PTR1+1
    tya
    asl                     // × 2
    rol ZP_PTR1+1
    asl                     // × 4
    rol ZP_PTR1+1
    asl                     // × 8
    rol ZP_PTR1+1
    sta ZP_PTR1
    
    // × 5 to get × 40
    lda ZP_PTR1
    asl
    rol ZP_PTR1+1
    asl
    rol ZP_PTR1+1
    clc
    adc ZP_PTR1
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #$00
    sta ZP_PTR1+1
    
    // Add column
    txa
    clc
    adc ZP_PTR1
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #$00
    sta ZP_PTR1+1
    
    // Add SCREEN_RAM base
    lda ZP_PTR1
    clc
    adc #<SCREEN_RAM
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #>SCREEN_RAM
    sta ZP_PTR1+1
    
    rts

// ============================================================================
// Print Character
// ============================================================================
// Inputs: A = character to print
// Uses: ZP_PTR1 = current cursor position
// Modifies: ZP_PTR1 (advances)
// ============================================================================
ui_print_char:
    ldy #$00
    sta (ZP_PTR1),y
    
    // Advance cursor
    inc ZP_PTR1
    bne print_char_done
    inc ZP_PTR1+1
    
print_char_done:
    rts

// ============================================================================
// Print String
// ============================================================================
// Inputs: X = low byte of string address
//         Y = high byte of string address
// String must be null-terminated
// Modifies: A, Y, ZP_PTR2
// ============================================================================
ui_print_string:
    stx ZP_PTR2
    sty ZP_PTR2+1
    
    ldy #$00
print_string_loop:
    lda (ZP_PTR2),y
    beq print_string_done
    jsr ui_print_char
    iny
    bne print_string_loop
    
print_string_done:
    rts

// ============================================================================
// Print Hex Byte
// ============================================================================
// Inputs: A = byte to print as hex
// Modifies: A
// ============================================================================
ui_print_hex_byte:
    pha
    lsr
    lsr
    lsr
    lsr
    jsr ui_print_hex_digit
    pla
    and #$0F
    jsr ui_print_hex_digit
    rts

ui_print_hex_digit:
    cmp #$0A
    bcc hex_is_digit
    clc
    adc #$07                // A-F offset
hex_is_digit:
    clc
    adc #$30                // '0' character
    jsr ui_print_char
    rts

// ============================================================================
// Print Decimal
// ============================================================================
// Inputs: A = byte to print as decimal (0-255)
// Modifies: A, X
// ============================================================================
ui_print_decimal:
    // Simple decimal conversion
    ldx #$00
    
decimal_hundreds:
    cmp #100
    bcc decimal_tens
    sbc #100
    inx
    jmp decimal_hundreds
    
decimal_tens:
    pha
    txa
    clc
    adc #$30
    jsr ui_print_char
    pla
    
    ldx #$00
decimal_tens_loop:
    cmp #10
    bcc decimal_ones
    sbc #10
    inx
    jmp decimal_tens_loop
    
decimal_ones:
    pha
    txa
    clc
    adc #$30
    jsr ui_print_char
    pla
    clc
    adc #$30
    jsr ui_print_char
    
    rts

// ============================================================================
// Print Waveform
// ============================================================================
// Inputs: A = waveform byte
// Prints waveform name (TRI, SAW, PUL, NOI)
// ============================================================================
ui_print_waveform:
    and #$F0                // Mask to waveform bits
    cmp #SID_TRIANGLE
    beq print_tri
    cmp #SID_SAWTOOTH
    beq print_saw
    cmp #SID_PULSE
    beq print_pul
    cmp #SID_NOISE
    beq print_noi
    
    // Unknown waveform
    ldx #<str_wf_unknown
    ldy #>str_wf_unknown
    jmp ui_print_string
    
print_tri:
    ldx #<str_wf_tri
    ldy #>str_wf_tri
    jmp ui_print_string
    
print_saw:
    ldx #<str_wf_saw
    ldy #>str_wf_saw
    jmp ui_print_string
    
print_pul:
    ldx #<str_wf_pul
    ldy #>str_wf_pul
    jmp ui_print_string
    
print_noi:
    ldx #<str_wf_noi
    ldy #>str_wf_noi
    jmp ui_print_string

// ============================================================================
// UI Strings
// ============================================================================
str_title:
    .text "SID SUPERSTATION V1.0", 0

str_patch_label:
    .text "P:", 0

str_osc_section:
    .text "OSC1:", 0

str_adsr_section:
    .text "A:04 D:08 S:12 R:06  [VOICE 1]", 0

str_filter_section:
    .text "FILTER: LP  CUT:1024 RES:08", 0

str_lfo_section:
    .text "LFO1:TRI", $1E, "PITCH  R:32 D:64", 0

str_fkeys_1:
    .text "F1:OSC F3:FILT F5:LFO F7:SEQ", 0

str_fkeys_2:
    .text "F2:ENV F4:ARP  F6:SAVE F8:LOAD", 0

str_seq_title:
    .text "SEQUENCER", 0

str_pat_label:
    .text "PAT:", 0

str_bpm_label:
    .text "BPM:", 0

str_step_header:
    .text "STEP:", 0

str_v1_label:
    .text "V1:", 0

str_transport:
    .text "[PLAY] [STOP] [REC] [EDIT]", 0

str_filter_page:
    .text "FILTER PARAMETERS", 0

str_lfo_page:
    .text "LFO PARAMETERS", 0

str_arp_page:
    .text "ARPEGGIATOR", 0

str_saveload_page:
    .text "SAVE / LOAD", 0

str_wf_tri:
    .text "TRI", 0

str_wf_saw:
    .text "SAW", 0

str_wf_pul:
    .text "PUL", 0

str_wf_noi:
    .text "NOI", 0

str_wf_unknown:
    .text "???", 0
