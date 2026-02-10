// ============================================================================
// SID SUPERSTATION - Input Handling
// ============================================================================
// Keyboard scanning and piano keyboard mode
// ============================================================================

// ============================================================================
// Input State Variables
// ============================================================================
.label input_last_key       = $0500     // Last key pressed
.label input_piano_mode     = $0501     // Piano mode enabled
.label input_octave         = $0502     // Current octave for piano mode
.label input_key_held       = $0503     // Key held flag (for repeat)

// Piano keyboard mapping
// Maps keyboard rows to MIDI notes
.label piano_notes          = $0510     // Array of held notes (for arpeggiator)
.label piano_note_count     = $0520     // Number of held notes

// ============================================================================
// Initialize Input System
// ============================================================================
input_init:
    lda #$00
    sta input_last_key
    sta input_key_held
    sta piano_note_count
    
    // Enable piano mode by default
    lda #$01
    sta input_piano_mode
    
    // Set default octave (C4)
    lda #$04
    sta input_octave
    
    rts

// ============================================================================
// Poll Keyboard
// ============================================================================
// Checks for keyboard input and processes it
// Called from main loop
// Modifies: A, X, Y
// ============================================================================
input_poll:
    // Get key from keyboard buffer
    jsr KERNAL_GETIN
    cmp #$00
    beq no_key_pressed
    
    // Store key
    sta input_last_key
    
    // Check for function keys first
    cmp #KEY_F1
    beq handle_f1
    cmp #KEY_F3
    beq handle_f3
    cmp #KEY_F5
    beq handle_f5
    cmp #KEY_F7
    beq handle_f7
    cmp #KEY_F2
    beq handle_f2
    cmp #KEY_F4
    beq handle_f4
    cmp #KEY_F6
    beq handle_f6
    cmp #KEY_F8
    beq handle_f8
    
    // Check for special keys
    cmp #KEY_RUNSTOP
    beq handle_runstop
    cmp #KEY_UP
    beq handle_up
    cmp #KEY_DOWN
    beq handle_down
    cmp #KEY_LEFT
    beq handle_left
    cmp #KEY_RIGHT
    beq handle_right
    cmp #KEY_PLUS
    beq handle_plus
    cmp #KEY_MINUS
    beq handle_minus
    
    // Check if piano mode is enabled
    lda input_piano_mode
    beq skip_piano_keys
    
    // Process piano keyboard
    lda input_last_key
    jsr input_process_piano_key
    
skip_piano_keys:
no_key_pressed:
    rts

// ============================================================================
// Function Key Handlers
// ============================================================================
handle_f1:                  // OSC page
    lda #PAGE_SYNTH
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f2:                  // ENV page (same as synth for now)
    lda #PAGE_SYNTH
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f3:                  // FILTER page
    lda #PAGE_FILTER
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f4:                  // ARP page
    lda #PAGE_ARP
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f5:                  // LFO page
    lda #PAGE_LFO
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f6:                  // SAVE page
    lda #PAGE_SAVE_LOAD
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f7:                  // SEQ page
    lda #PAGE_SEQUENCER
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

handle_f8:                  // LOAD page (same as save)
    lda #PAGE_SAVE_LOAD
    sta ui_current_page
    lda #$01
    sta ui_dirty_flag
    rts

// ============================================================================
// Special Key Handlers
// ============================================================================
handle_runstop:
    // Toggle sequencer playback
    lda seq_playing
    beq start_playback
    
stop_playback:
    jsr seq_stop
    rts
    
start_playback:
    jsr seq_start
    rts

handle_up:
    // Navigate up in UI
    lda ui_cursor_y
    beq up_at_top
    dec ui_cursor_y
    lda #$01
    sta ui_dirty_flag
up_at_top:
    rts

handle_down:
    // Navigate down in UI
    lda ui_cursor_y
    cmp #24
    beq down_at_bottom
    inc ui_cursor_y
    lda #$01
    sta ui_dirty_flag
down_at_bottom:
    rts

handle_left:
    // Navigate left in UI
    lda ui_cursor_x
    beq left_at_edge
    dec ui_cursor_x
    lda #$01
    sta ui_dirty_flag
left_at_edge:
    rts

handle_right:
    // Navigate right in UI
    lda ui_cursor_x
    cmp #39
    beq right_at_edge
    inc ui_cursor_x
    lda #$01
    sta ui_dirty_flag
right_at_edge:
    rts

handle_plus:
    // Increment selected parameter
    // TODO: Implement parameter editing
    rts

handle_minus:
    // Decrement selected parameter
    // TODO: Implement parameter editing
    rts

// ============================================================================
// Process Piano Key
// ============================================================================
// Maps keyboard keys to musical notes and triggers SID voices
// Inputs: A = key code
// Modifies: A, X, Y
// ============================================================================
input_process_piano_key:
    // Piano keyboard layout:
    // Top row (black keys): 1 2 3 4 5 6 7 8 9 0
    //                      C# D# F# G# A#  (repeat)
    // Bottom row (white keys): Q W E R T Y U I O P
    //                         C  D  E F  G  A  B C
    
    ldx #$00                // Note offset
    
    // Check white keys first
    cmp #'Q'                // C
    beq play_piano_c
    cmp #'W'                // D
    beq play_piano_d
    cmp #'E'                // E
    beq play_piano_e
    cmp #'R'                // F
    beq play_piano_f
    cmp #'T'                // G
    beq play_piano_g
    cmp #'Y'                // A
    beq play_piano_a
    cmp #'U'                // B
    beq play_piano_b
    cmp #'I'                // C (upper octave)
    beq play_piano_c_high
    
    // Check black keys
    cmp #'2'                // C#
    beq play_piano_cs
    cmp #'3'                // D#
    beq play_piano_ds
    cmp #'5'                // F#
    beq play_piano_fs
    cmp #'6'                // G#
    beq play_piano_gs
    cmp #'7'                // A#
    beq play_piano_as
    
    // Octave shift keys
    cmp #'Z'                // Octave down
    beq octave_down
    cmp #'X'                // Octave up
    beq octave_up
    
    rts

// White keys
play_piano_c:
    ldx #0
    jmp play_piano_note
    
play_piano_d:
    ldx #2
    jmp play_piano_note
    
play_piano_e:
    ldx #4
    jmp play_piano_note
    
play_piano_f:
    ldx #5
    jmp play_piano_note
    
play_piano_g:
    ldx #7
    jmp play_piano_note
    
play_piano_a:
    ldx #9
    jmp play_piano_note
    
play_piano_b:
    ldx #11
    jmp play_piano_note
    
play_piano_c_high:
    ldx #12
    jmp play_piano_note

// Black keys
play_piano_cs:
    ldx #1
    jmp play_piano_note
    
play_piano_ds:
    ldx #3
    jmp play_piano_note
    
play_piano_fs:
    ldx #6
    jmp play_piano_note
    
play_piano_gs:
    ldx #8
    jmp play_piano_note
    
play_piano_as:
    ldx #10
    jmp play_piano_note

// ============================================================================
// Play Piano Note
// ============================================================================
// Calculates MIDI note and plays it on voice 1
// Inputs: X = note offset (0-11 = C to B)
// Modifies: A, X, Y
// ============================================================================
play_piano_note:
    // Calculate MIDI note = (octave * 12) + offset
    lda input_octave
    
    // Multiply by 12
    sta ZP_TEMP
    asl                     // × 2
    asl                     // × 4
    clc
    adc ZP_TEMP             // × 5
    asl                     // × 10
    clc
    adc ZP_TEMP             // × 11
    clc
    adc ZP_TEMP             // × 12
    
    // Add note offset
    stx ZP_TEMP
    clc
    adc ZP_TEMP
    
    // Play note on voice 1
    ldx #$00                // Voice 1
    ldy #$80                // Velocity
    jsr synth_play_note
    
    // Add to held notes array (for arpeggiator)
    ldx piano_note_count
    sta piano_notes,x
    inc piano_note_count
    
    rts

// ============================================================================
// Octave Control
// ============================================================================
octave_down:
    lda input_octave
    beq octave_min
    dec input_octave
octave_min:
    rts

octave_up:
    lda input_octave
    cmp #$07
    beq octave_max
    inc input_octave
octave_max:
    rts

// ============================================================================
// Release All Notes
// ============================================================================
// Releases all held piano notes
// Called when switching modes or stopping
// ============================================================================
input_release_all_notes:
    ldx #$00
release_loop:
    jsr synth_release_note
    inx
    cpx #NUM_VOICES
    bne release_loop
    
    // Clear held notes
    lda #$00
    sta piano_note_count
    
    rts

// ============================================================================
// Joystick Input (Port 2)
// ============================================================================
// Reads joystick for parameter control
// Modifies: A
// ============================================================================
input_read_joystick:
    lda $DC00               // CIA1 Port A (Joystick 2)
    
    // Check directions (active low)
    and #$1F
    cmp #$1F
    beq joy_no_input
    
    // TODO: Map joystick to parameter control
    
joy_no_input:
    rts
