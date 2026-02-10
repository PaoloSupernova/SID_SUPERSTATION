// ============================================================================
// SID SUPERSTATION - Pattern Sequencer
// ============================================================================
// 16-step pattern sequencer with 3 tracks (one per SID voice)
// ============================================================================

// ============================================================================
// Sequencer State Variables
// ============================================================================
.label seq_playing          = $0300     // Playback state (0=stopped, 1=playing)
.label seq_recording        = $0301     // Recording state (0=off, 1=on)
.label seq_current_pattern  = $0302     // Current pattern number (0-31)
.label seq_current_step     = $0303     // Current step (0-15)
.label seq_tempo            = $0304     // Tempo in BPM
.label seq_swing            = $0305     // Swing amount (0-100)
.label seq_timer_count      = $0306     // Timer tick counter (2 bytes)
.label seq_ticks_per_step   = $0308     // Ticks per step (2 bytes)

// Song mode
.label song_mode            = $0310     // Song mode enabled
.label song_position        = $0311     // Current position in song
.label song_length          = $0312     // Song length in patterns
.label song_chain           = $0320     // Song chain array (64 bytes)

// ============================================================================
// Initialize Sequencer
// ============================================================================
seq_init:
    // Clear sequencer state
    lda #$00
    sta seq_playing
    sta seq_recording
    sta seq_current_pattern
    sta seq_current_step
    sta song_mode
    sta song_position
    
    // Set default tempo
    lda #DEFAULT_TEMPO
    sta seq_tempo
    
    // Set default swing
    lda #$00
    sta seq_swing
    
    // Calculate ticks per step based on tempo
    jsr seq_update_tempo
    
    // Clear all patterns
    jsr seq_clear_all_patterns
    
    rts

// ============================================================================
// Update Tempo
// ============================================================================
// Recalculates timing values based on current tempo
// Inputs: seq_tempo = BPM value
// Outputs: Updates seq_ticks_per_step
// Modifies: A, X, Y
// ============================================================================
seq_update_tempo:
    // Calculate ticks per step
    // For PAL: 50 Hz frame rate
    // Ticks per step = (50 * 60) / (tempo * 4)
    // Simplified: We'll use a lookup table or formula
    
    // For now, use a simple approximation
    lda seq_tempo
    cmp #120
    beq tempo_120
    
    // Default to 120 BPM timing
tempo_120:
    lda #$06                // Approximately 120 BPM
    sta seq_ticks_per_step
    lda #$00
    sta seq_ticks_per_step+1
    
    rts

// ============================================================================
// Start Playback
// ============================================================================
seq_start:
    lda #$01
    sta seq_playing
    
    // Reset step counter
    lda #$00
    sta seq_current_step
    sta seq_timer_count
    sta seq_timer_count+1
    
    rts

// ============================================================================
// Stop Playback
// ============================================================================
seq_stop:
    lda #$00
    sta seq_playing
    
    // Release all notes
    ldx #$00
stop_voice_loop:
    jsr synth_release_note
    inx
    cpx #NUM_VOICES
    bne stop_voice_loop
    
    // Reset to beginning
    lda #$00
    sta seq_current_step
    
    rts

// ============================================================================
// Sequencer Tick
// ============================================================================
// Called from interrupt routine (50/60 Hz)
// Advances the sequencer and triggers notes
// Modifies: A, X, Y
// ============================================================================
seq_tick:
    // Check if playing
    lda seq_playing
    beq tick_done
    
    // Increment timer
    inc seq_timer_count
    bne check_step_time
    inc seq_timer_count+1
    
check_step_time:
    // Check if it's time for next step
    lda seq_timer_count
    cmp seq_ticks_per_step
    lda seq_timer_count+1
    sbc seq_ticks_per_step+1
    bcc tick_done           // Not yet time for next step
    
    // Reset timer
    lda #$00
    sta seq_timer_count
    sta seq_timer_count+1
    
    // Advance step
    inc seq_current_step
    lda seq_current_step
    cmp #PATTERN_LENGTH
    bcc process_step
    
    // Wrap to beginning or advance to next pattern
    lda song_mode
    beq wrap_pattern
    
    // Song mode: advance to next pattern
    inc song_position
    lda song_position
    cmp song_length
    bcc load_next_pattern
    
    // End of song: wrap to beginning
    lda #$00
    sta song_position
    
load_next_pattern:
    ldx song_position
    lda song_chain,x
    sta seq_current_pattern
    
wrap_pattern:
    lda #$00
    sta seq_current_step
    
process_step:
    // Process current step for all voices
    jsr seq_process_step
    
tick_done:
    rts

// ============================================================================
// Process Current Step
// ============================================================================
// Reads pattern data and triggers notes for all voices
// Inputs: seq_current_pattern, seq_current_step
// Outputs: Triggers notes on SID voices
// Modifies: A, X, Y, ZP_PTR1
// ============================================================================
seq_process_step:
    // Calculate pattern data address
    // Address = PATTERN_DATA + (pattern * PATTERN_SIZE) + (step * STEP_SIZE * 3)
    
    lda seq_current_pattern
    sta ZP_TEMP
    
    // Multiply pattern by 256 (PATTERN_SIZE)
    lda #$00
    sta ZP_PTR1
    lda ZP_TEMP
    sta ZP_PTR1+1
    
    // Add PATTERN_DATA base
    lda ZP_PTR1
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #>PATTERN_DATA
    sta ZP_PTR1+1
    
    // Add step offset (step * 12, since 3 voices × 4 bytes per voice)
    lda seq_current_step
    asl
    asl                     // × 4
    sta ZP_TEMP
    asl                     // × 8
    clc
    adc ZP_TEMP             // × 12
    clc
    adc ZP_PTR1
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #$00
    sta ZP_PTR1+1
    
    // Now process each voice
    ldx #$00                // Voice counter
    
process_voice_loop:
    // Calculate offset for this voice (voice * 4)
    txa
    asl
    asl
    tay
    
    // Read note value
    lda (ZP_PTR1),y
    cmp #STEP_REST
    beq voice_rest
    cmp #STEP_TIE
    beq voice_tie
    
    // Play note
    sta ZP_TEMP             // Save note
    iny
    lda (ZP_PTR1),y         // Read velocity
    tay
    lda ZP_TEMP             // Restore note
    jsr synth_play_note
    jmp process_next_voice
    
voice_rest:
    // Rest: release note
    jsr synth_release_note
    jmp process_next_voice
    
voice_tie:
    // Tie: keep note playing (do nothing)
    
process_next_voice:
    inx
    cpx #NUM_VOICES
    bne process_voice_loop
    
    rts

// ============================================================================
// Write Step
// ============================================================================
// Writes note data to a pattern step
// Inputs: A = pattern number
//         X = step number (0-15)
//         Y = voice number (0-2)
//         ZP_PTR1 = pointer to 4-byte step data
// Outputs: Writes data to pattern memory
// Modifies: A, X, Y, ZP_PTR2
// ============================================================================
seq_write_step:
    // Calculate pattern address
    sta ZP_TEMP             // Save pattern number
    stx ZP_TEMP2            // Save step number
    sty ZP_TEMP+1           // Save voice number
    
    // Pattern base address
    lda #$00
    sta ZP_PTR2
    lda ZP_TEMP
    sta ZP_PTR2+1
    
    lda ZP_PTR2
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #>PATTERN_DATA
    sta ZP_PTR2+1
    
    // Add step offset
    lda ZP_TEMP2
    asl
    asl
    sta ZP_TEMP
    asl
    clc
    adc ZP_TEMP
    clc
    adc ZP_PTR2
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #$00
    sta ZP_PTR2+1
    
    // Add voice offset
    lda ZP_TEMP+1
    asl
    asl
    clc
    adc ZP_PTR2
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #$00
    sta ZP_PTR2+1
    
    // Copy 4 bytes from ZP_PTR1 to ZP_PTR2
    ldy #$00
copy_step_loop:
    lda (ZP_PTR1),y
    sta (ZP_PTR2),y
    iny
    cpy #$04
    bne copy_step_loop
    
    rts

// ============================================================================
// Read Step
// ============================================================================
// Reads note data from a pattern step
// Inputs: A = pattern number
//         X = step number (0-15)
//         Y = voice number (0-2)
//         ZP_PTR1 = pointer to receive 4-byte step data
// Outputs: Reads data from pattern memory to ZP_PTR1
// Modifies: A, X, Y, ZP_PTR2
// ============================================================================
seq_read_step:
    // Calculate pattern address (same logic as write_step)
    sta ZP_TEMP
    stx ZP_TEMP2
    sty ZP_TEMP+1
    
    lda #$00
    sta ZP_PTR2
    lda ZP_TEMP
    sta ZP_PTR2+1
    
    lda ZP_PTR2
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #>PATTERN_DATA
    sta ZP_PTR2+1
    
    lda ZP_TEMP2
    asl
    asl
    sta ZP_TEMP
    asl
    clc
    adc ZP_TEMP
    clc
    adc ZP_PTR2
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #$00
    sta ZP_PTR2+1
    
    lda ZP_TEMP+1
    asl
    asl
    clc
    adc ZP_PTR2
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #$00
    sta ZP_PTR2+1
    
    // Copy 4 bytes from ZP_PTR2 to ZP_PTR1
    ldy #$00
copy_read_loop:
    lda (ZP_PTR2),y
    sta (ZP_PTR1),y
    iny
    cpy #$04
    bne copy_read_loop
    
    rts

// ============================================================================
// Clear Pattern
// ============================================================================
// Clears all data in a pattern
// Inputs: A = pattern number
// Outputs: Pattern is filled with rests
// Modifies: A, X, Y, ZP_PTR1
// ============================================================================
seq_clear_pattern:
    // Calculate pattern address
    sta ZP_TEMP
    
    lda #$00
    sta ZP_PTR1
    lda ZP_TEMP
    sta ZP_PTR1+1
    
    lda ZP_PTR1
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #>PATTERN_DATA
    sta ZP_PTR1+1
    
    // Fill with rests
    ldy #$00
    lda #STEP_REST
clear_loop:
    sta (ZP_PTR1),y
    iny
    bne clear_loop          // Clear 256 bytes
    
    rts

// ============================================================================
// Clear All Patterns
// ============================================================================
seq_clear_all_patterns:
    ldx #$00
clear_all_loop:
    txa
    jsr seq_clear_pattern
    inx
    cpx #NUM_PATTERNS
    bne clear_all_loop
    
    rts

// ============================================================================
// Copy Pattern
// ============================================================================
// Copies one pattern to another
// Inputs: A = source pattern
//         X = destination pattern
// Outputs: Pattern is copied
// Modifies: A, X, Y, ZP_PTR1, ZP_PTR2
// ============================================================================
seq_copy_pattern:
    // Calculate source address
    sta ZP_TEMP
    stx ZP_TEMP2
    
    lda #$00
    sta ZP_PTR1
    lda ZP_TEMP
    sta ZP_PTR1+1
    
    lda ZP_PTR1
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR1
    lda ZP_PTR1+1
    adc #>PATTERN_DATA
    sta ZP_PTR1+1
    
    // Calculate destination address
    lda #$00
    sta ZP_PTR2
    lda ZP_TEMP2
    sta ZP_PTR2+1
    
    lda ZP_PTR2
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #>PATTERN_DATA
    sta ZP_PTR2+1
    
    // Copy 256 bytes
    ldy #$00
copy_pattern_loop:
    lda (ZP_PTR1),y
    sta (ZP_PTR2),y
    iny
    bne copy_pattern_loop
    
    rts
