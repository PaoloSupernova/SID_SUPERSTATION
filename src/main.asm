// ============================================================================
// SID SUPERSTATION - Main Program
// ============================================================================
// Commodore 64 SID Chip Synthesizer and Sequencer
// Version 1.0
// ============================================================================
// Entry point and main loop
// ============================================================================

// Import constants FIRST - all other files depend on these
#import "constants.asm"

// Set up basic C64 program header
.pc = $0801 "Basic Upstart"
:BasicUpstart(start)

// ============================================================================
// Main Program Start
// ============================================================================
.pc = PRG_START "Main Program"

start:
    // Disable interrupts during initialization
    sei
    
    // Turn off screen to avoid flicker during setup
    lda #$00
    sta VIC_BASE + $11      // Screen off
    
    // Initialize all subsystems
    jsr sid_init
    jsr synth_init
    jsr seq_init
    jsr ui_init
    jsr input_init
    jsr storage_init
    
    // Set up interrupt handler
    jsr setup_interrupt
    
    // Turn screen back on
    lda #$1B
    sta VIC_BASE + $11      // Screen on, 25 rows
    
    // Enable interrupts
    cli
    
    // Load default patch
    lda #$00
    jsr synth_load_patch
    
    // Force initial screen draw
    lda #$01
    sta ui_dirty_flag
    
    // Fall through to main loop

// ============================================================================
// Main Loop
// ============================================================================
// Handles UI updates and input processing
// The interrupt handler takes care of sequencer and LFO updates
// ============================================================================
main_loop:
    // Poll for keyboard input
    jsr input_poll
    
    // Update UI if needed
    jsr ui_update
    
    // Small delay to reduce CPU load
    // (Most work happens in interrupt)
    ldx #$10
delay_loop:
    nop
    dex
    bne delay_loop
    
    // Loop forever
    jmp main_loop

// ============================================================================
// Interrupt Setup
// ============================================================================
// Sets up raster interrupt for timing-critical tasks
// ============================================================================
setup_interrupt:
    // Save old interrupt vector
    lda $0314
    sta old_irq_vector
    lda $0315
    sta old_irq_vector+1
    
    // Disable CIA interrupts
    lda #$7F
    sta CIA1_ICR
    
    // Set up raster interrupt
    lda #$1B
    sta VIC_IMR             // Enable raster interrupt
    
    lda #$00                // Raster line 0
    sta VIC_RASTER
    
    // Install new interrupt handler
    lda #<irq_handler
    sta $0314
    lda #>irq_handler
    sta $0315
    
    rts

// Storage for old IRQ vector
old_irq_vector:
    .byte $00, $00

// ============================================================================
// Interrupt Handler
// ============================================================================
// Called 50/60 times per second (PAL/NTSC)
// Handles time-critical synthesis and sequencer tasks
// ============================================================================
irq_handler:
    // Acknowledge interrupt
    lda VIC_IRQ
    sta VIC_IRQ
    
    // Save registers
    pha
    txa
    pha
    tya
    pha
    
    // Update sequencer
    jsr seq_tick
    
    // Update LFOs
    jsr synth_update_lfos
    
    // Apply LFO modulation
    jsr synth_apply_lfo_modulation
    
    // Update arpeggiator
    jsr synth_update_arpeggiator
    
    // Restore registers
    pla
    tay
    pla
    tax
    pla
    
    // Exit interrupt
    jmp $EA31               // Jump to kernal IRQ exit

// ============================================================================
// Include all modules
// ============================================================================
#import "tables.asm"
#import "sid.asm"
#import "synth_engine.asm"
#import "sequencer.asm"
#import "ui.asm"
#import "input.asm"
#import "storage.asm"

// ============================================================================
// Data Section
// ============================================================================
// Reserve memory areas for patches and patterns
// ============================================================================

.pc = PATCH_DATA "Patch Data"
patch_memory:
    .fill NUM_PATCHES * PATCH_SIZE, $00

.pc = PATTERN_DATA "Pattern Data"
pattern_memory:
    .fill NUM_PATTERNS * PATTERN_SIZE, $FF  // Fill with rests

// ============================================================================
// Default Patches
// ============================================================================
// Include some factory presets

.pc = * "Default Patches"
default_patches:
    // Patch 0: Basic Triangle Lead
    .text "TRIANLGE"         // Name (8 chars)
    .byte SID_TRIANGLE      // Voice 1 waveform
    .byte $44               // Attack=4, Decay=4
    .byte $88               // Sustain=8, Release=8
    .word $0800             // Pulse width
    .byte $00               // Octave shift
    .byte $00               // Detune
    .byte SID_PULSE         // Voice 2 waveform
    .byte $33               // Attack=3, Decay=3
    .byte $77               // Sustain=7, Release=7
    .word $0400             // Pulse width
    .byte $00               // Octave shift
    .byte $00               // Detune
    .byte SID_SAWTOOTH      // Voice 3 waveform
    .byte $22               // Attack=2, Decay=2
    .byte $66               // Sustain=6, Release=6
    .word $0000             // Pulse width (N/A for sawtooth)
    .byte $00               // Octave shift
    .byte $00               // Detune
    .byte $00, $00          // Filter cutoff (11-bit)
    .byte $00               // Filter resonance
    .byte $00               // Filter mode & routing
    .byte $00, $00, $00, $00  // LFO1 (waveform, rate, depth, dest)
    .byte $00, $00, $00, $00  // LFO2
    .byte $00, $00, $00, $00  // LFO3
    .byte $00, $00, $00, $00  // LFO4
    .byte $00               // Arp mode
    .byte $04               // Arp speed
    .byte $01               // Arp range
    .fill 12, $00           // Reserved

// ============================================================================
// Program Info
// ============================================================================
program_info:
    .text "SID SUPERSTATION V1.0"
    .byte $00
    .text "COMMODORE 64 SYNTHESIZER"
    .byte $00
    .text "(C) 2026"
    .byte $00

// ============================================================================
// End of Program
// ============================================================================
