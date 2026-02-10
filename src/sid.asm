// ============================================================================
// SID SUPERSTATION - SID Chip Control Layer
// ============================================================================
// Low-level SID chip register control and voice management
// ============================================================================

// ============================================================================
// Initialize SID Chip
// ============================================================================
// Resets all SID registers to default state
// Inputs: None
// Outputs: None
// Modifies: A, X
// ============================================================================
sid_init:
    ldx #$00
    
    // Clear all SID registers
clear_sid_loop:
    lda #$00
    sta SID_BASE,x
    inx
    cpx #$1D                // 29 registers total
    bne clear_sid_loop
    
    // Set default volume
    lda #$0F                // Maximum volume
    sta SID_MODE_VOL
    
    // Set default filter settings
    lda #$00
    sta SID_FC_LO
    sta SID_FC_HI
    sta SID_RES_FILT
    
    rts

// ============================================================================
// Set Voice Frequency
// ============================================================================
// Sets the frequency for a given voice
// Inputs: X = voice number (0-2)
//         A = MIDI note number (0-95)
// Outputs: None
// Modifies: A, Y, ZP_PTR1
// ============================================================================
sid_set_note:
    // Calculate voice base address
    stx ZP_TEMP             // Save voice number
    sta ZP_TEMP2            // Save note number
    
    // Load frequency from table
    tay                     // Note number to Y
    lda freq_table_lo,y
    sta ZP_PTR1             // Store low byte temporarily
    lda freq_table_hi,y
    sta ZP_PTR1+1           // Store high byte temporarily
    
    // Calculate SID register offset for voice
    ldx ZP_TEMP             // Restore voice number
    lda voice_offset_table,x
    tax                     // X now has the base offset for this voice
    
    // Write frequency to SID
    lda ZP_PTR1             // Low byte
    sta SID_BASE,x          // Voice X freq low
    inx
    lda ZP_PTR1+1           // High byte
    sta SID_BASE,x          // Voice X freq high
    
    rts

// Voice register offset table
voice_offset_table:
    .byte $00, $07, $0E     // Voice 1 at $D400, Voice 2 at $D407, Voice 3 at $D40E

// ============================================================================
// Set Voice Waveform
// ============================================================================
// Sets the waveform for a given voice
// Inputs: X = voice number (0-2)
//         A = waveform byte (use SID_TRIANGLE, SID_SAWTOOTH, etc.)
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_set_waveform:
    // Calculate control register address
    stx ZP_TEMP             // Save waveform
    lda voice_control_table,x
    tax                     // X = control register offset
    lda ZP_TEMP             // Restore waveform
    sta SID_BASE,x          // Write to control register
    
    rts

// Voice control register offset table
voice_control_table:
    .byte $04, $0B, $12     // $D404, $D40B, $D412

// ============================================================================
// Set Voice ADSR
// ============================================================================
// Sets the ADSR envelope for a given voice
// Inputs: X = voice number (0-2)
//         A = Attack/Decay byte (high nibble = attack, low nibble = decay)
//         Y = Sustain/Release byte (high nibble = sustain, low nibble = release)
// Outputs: None
// Modifies: None (A, Y preserved via stack)
// ============================================================================
sid_set_adsr:
    // Save registers
    pha
    tya
    pha
    txa
    
    // Calculate AD register address
    tax
    lda voice_ad_table,x
    tax
    pla                     // Restore Y to A
    sta SID_BASE,x          // Write SR
    dex
    pla                     // Restore A
    sta SID_BASE,x          // Write AD
    
    rts

// Voice AD register offset table
voice_ad_table:
    .byte $05, $0C, $13     // $D405, $D40C, $D413

// ============================================================================
// Gate Voice On
// ============================================================================
// Turns on the gate for a voice (starts note)
// Inputs: X = voice number (0-2)
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_gate_on:
    lda voice_control_table,x
    tay                     // Y = control register offset
    lda SID_BASE,y          // Read current control value
    ora #SID_GATE           // Set gate bit
    sta SID_BASE,y          // Write back
    
    rts

// ============================================================================
// Gate Voice Off
// ============================================================================
// Turns off the gate for a voice (releases note)
// Inputs: X = voice number (0-2)
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_gate_off:
    lda voice_control_table,x
    tay                     // Y = control register offset
    lda SID_BASE,y          // Read current control value
    and #($FF - SID_GATE)   // Clear gate bit
    sta SID_BASE,y          // Write back
    
    rts

// ============================================================================
// Set Pulse Width
// ============================================================================
// Sets the pulse width for a voice
// Inputs: X = voice number (0-2)
//         ZP_PTR1 = 16-bit pulse width value (12-bit used)
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_set_pulse_width:
    lda voice_pw_table,x
    tay                     // Y = pulse width register offset
    
    // Write low byte
    lda ZP_PTR1
    sta SID_BASE,y
    
    // Write high byte (only low 4 bits are used)
    iny
    lda ZP_PTR1+1
    and #$0F                // Mask to 12-bit value
    sta SID_BASE,y
    
    rts

// Voice pulse width register offset table
voice_pw_table:
    .byte $02, $09, $10     // $D402, $D409, $D410

// ============================================================================
// Set Filter Cutoff
// ============================================================================
// Sets the filter cutoff frequency
// Inputs: ZP_PTR1 = 11-bit cutoff value (0-2047)
// Outputs: None
// Modifies: A
// ============================================================================
sid_set_filter_cutoff:
    // Write low 3 bits to $D415
    lda ZP_PTR1
    and #$07
    sta SID_FC_LO
    
    // Write high 8 bits to $D416
    lda ZP_PTR1+1
    sta SID_FC_HI
    
    rts

// ============================================================================
// Set Filter Resonance
// ============================================================================
// Sets the filter resonance
// Inputs: A = resonance value (0-15)
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_set_filter_resonance:
    // Shift to high nibble
    asl
    asl
    asl
    asl
    
    // Preserve filter routing bits
    sta ZP_TEMP
    lda SID_RES_FILT
    and #$0F                // Keep low nibble (routing)
    ora ZP_TEMP             // Combine with resonance
    sta SID_RES_FILT
    
    rts

// ============================================================================
// Set Filter Mode
// ============================================================================
// Sets the filter mode (LP/BP/HP)
// Inputs: A = filter mode byte (use FILT_LP, FILT_BP, FILT_HP)
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_set_filter_mode:
    // Preserve volume bits
    sta ZP_TEMP
    lda SID_MODE_VOL
    and #$0F                // Keep low nibble (volume)
    ora ZP_TEMP             // Combine with filter mode
    sta SID_MODE_VOL
    
    rts

// ============================================================================
// Set Filter Voice Routing
// ============================================================================
// Routes voices through the filter
// Inputs: A = routing byte (bit 0=V1, bit 1=V2, bit 2=V3)
// Outputs: None
// Modifies: A
// ============================================================================
sid_set_filter_routing:
    sta ZP_TEMP
    lda SID_RES_FILT
    and #$F0                // Keep high nibble (resonance)
    ora ZP_TEMP             // Combine with routing
    sta SID_RES_FILT
    
    rts

// ============================================================================
// Set Master Volume
// ============================================================================
// Sets the master volume
// Inputs: A = volume value (0-15)
// Outputs: None
// Modifies: A
// ============================================================================
sid_set_volume:
    and #$0F                // Ensure 4-bit value
    sta ZP_TEMP
    lda SID_MODE_VOL
    and #$F0                // Keep high nibble (filter mode)
    ora ZP_TEMP             // Combine with volume
    sta SID_MODE_VOL
    
    rts

// ============================================================================
// Enable Hard Sync
// ============================================================================
// Enables hard sync between voices
// Inputs: X = voice number (0-2) - voice that will be synced
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_enable_sync:
    lda voice_control_table,x
    tay
    lda SID_BASE,y
    ora #SID_SYNC           // Set sync bit
    sta SID_BASE,y
    
    rts

// ============================================================================
// Enable Ring Modulation
// ============================================================================
// Enables ring modulation between voices
// Inputs: X = voice number (0-2) - voice that will be ring modulated
// Outputs: None
// Modifies: A, Y
// ============================================================================
sid_enable_ring_mod:
    lda voice_control_table,x
    tay
    lda SID_BASE,y
    ora #SID_RING           // Set ring mod bit
    sta SID_BASE,y
    
    rts

// ============================================================================
// Disable Hard Sync
// ============================================================================
sid_disable_sync:
    lda voice_control_table,x
    tay
    lda SID_BASE,y
    and #($FF - SID_SYNC)   // Clear sync bit
    sta SID_BASE,y
    
    rts

// ============================================================================
// Disable Ring Modulation
// ============================================================================
sid_disable_ring_mod:
    lda voice_control_table,x
    tay
    lda SID_BASE,y
    and #($FF - SID_RING)   // Clear ring mod bit
    sta SID_BASE,y
    
    rts
