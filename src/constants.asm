// ============================================================================
// SID SUPERSTATION - Constants and Memory Map
// ============================================================================
// Defines all system constants, memory locations, and SID register addresses
// ============================================================================

// ----------------------------------------------------------------------------
// System Constants
// ----------------------------------------------------------------------------
.const SCREEN_RAM       = $0400     // Screen memory
.const COLOR_RAM        = $D800     // Color memory
.const CHARSET_ROM      = $D000     // Character ROM location

// ----------------------------------------------------------------------------
// Memory Map
// ----------------------------------------------------------------------------
.const PRG_START        = $0810     // Program start (after BASIC area)
.const CODE_START       = $0810     // Main code area
.const PATCH_DATA       = $4000     // Patch storage (128 patches × 64 bytes = 8KB)
.const PATTERN_DATA     = $6000     // Pattern storage (32 patterns × 256 bytes = 8KB)
.const FREQ_TABLE       = $8000     // Frequency table for notes
.const LFO_TABLE        = $8800     // LFO waveform tables
.const UI_BUFFER        = $C000     // UI rendering buffer

// ----------------------------------------------------------------------------
// SID Chip Registers ($D400-$D41C)
// ----------------------------------------------------------------------------
.const SID_BASE         = $D400

// Voice 1 Registers
.const SID_V1_FREQ_LO   = $D400     // Voice 1 Frequency Low Byte
.const SID_V1_FREQ_HI   = $D401     // Voice 1 Frequency High Byte
.const SID_V1_PW_LO     = $D402     // Voice 1 Pulse Width Low Byte
.const SID_V1_PW_HI     = $D403     // Voice 1 Pulse Width High Byte
.const SID_V1_CONTROL   = $D404     // Voice 1 Control Register
.const SID_V1_AD        = $D405     // Voice 1 Attack/Decay
.const SID_V1_SR        = $D406     // Voice 1 Sustain/Release

// Voice 2 Registers
.const SID_V2_FREQ_LO   = $D407
.const SID_V2_FREQ_HI   = $D408
.const SID_V2_PW_LO     = $D409
.const SID_V2_PW_HI     = $D40A
.const SID_V2_CONTROL   = $D40B
.const SID_V2_AD        = $D40C
.const SID_V2_SR        = $D40D

// Voice 3 Registers
.const SID_V3_FREQ_LO   = $D40E
.const SID_V3_FREQ_HI   = $D40F
.const SID_V3_PW_LO     = $D410
.const SID_V3_PW_HI     = $D411
.const SID_V3_CONTROL   = $D412
.const SID_V3_AD        = $D413
.const SID_V3_SR        = $D414

// Filter and Volume Registers
.const SID_FC_LO        = $D415     // Filter Cutoff Low Byte
.const SID_FC_HI        = $D416     // Filter Cutoff High Byte
.const SID_RES_FILT     = $D417     // Resonance & Filter Routing
.const SID_MODE_VOL     = $D418     // Filter Mode & Volume

// ----------------------------------------------------------------------------
// SID Control Register Bits
// ----------------------------------------------------------------------------
.const SID_GATE         = %00000001 // Gate bit
.const SID_SYNC         = %00000010 // Sync bit
.const SID_RING         = %00000100 // Ring Modulation bit
.const SID_TEST         = %00001000 // Test bit (resets oscillator)
.const SID_TRIANGLE     = %00010000 // Triangle waveform
.const SID_SAWTOOTH     = %00100000 // Sawtooth waveform
.const SID_PULSE        = %01000000 // Pulse waveform
.const SID_NOISE        = %10000000 // Noise waveform

// ----------------------------------------------------------------------------
// Filter Mode Bits
// ----------------------------------------------------------------------------
.const FILT_LP          = %00010000 // Low-pass filter
.const FILT_BP          = %00100000 // Band-pass filter
.const FILT_HP          = %01000000 // High-pass filter
.const FILT_3OFF        = %10000000 // Disconnect Voice 3

// ----------------------------------------------------------------------------
// CIA Timer Registers
// ----------------------------------------------------------------------------
.const CIA1_BASE        = $DC00
.const CIA2_BASE        = $DD00
.const CIA1_TIMERA_LO   = $DC04
.const CIA1_TIMERA_HI   = $DC05
.const CIA1_TIMERB_LO   = $DC06
.const CIA1_TIMERB_HI   = $DC07
.const CIA1_ICR         = $DC0D
.const CIA1_CRA         = $DC0E     // Control Register A
.const CIA1_CRB         = $DC0F     // Control Register B

// ----------------------------------------------------------------------------
// VIC-II Registers
// ----------------------------------------------------------------------------
.const VIC_BASE         = $D000
.const VIC_RASTER       = $D012     // Raster line register
.const VIC_IRQ          = $D019     // Interrupt register
.const VIC_IMR          = $D01A     // Interrupt mask register
.const VIC_BORDER       = $D020     // Border color
.const VIC_BACKGROUND   = $D021     // Background color

// ----------------------------------------------------------------------------
// Kernal Routines
// ----------------------------------------------------------------------------
.const KERNAL_SETNAM    = $FFBD     // Set filename
.const KERNAL_SETLFS    = $FFBA     // Set logical file parameters
.const KERNAL_OPEN      = $FFC0     // Open file
.const KERNAL_CLOSE     = $FFC3     // Close file
.const KERNAL_CHKIN     = $FFC6     // Set input channel
.const KERNAL_CHKOUT    = $FFC9     // Set output channel
.const KERNAL_CLRCHN    = $FFCC     // Clear I/O channels
.const KERNAL_CHRIN     = $FFCF     // Input character
.const KERNAL_CHROUT    = $FFD2     // Output character
.const KERNAL_LOAD      = $FFD5     // Load file
.const KERNAL_SAVE      = $FFD8     // Save file
.const KERNAL_GETIN     = $FFE4     // Get character from keyboard

// ----------------------------------------------------------------------------
// Keyboard Scan Codes
// ----------------------------------------------------------------------------
.const KEY_F1           = $85
.const KEY_F2           = $89
.const KEY_F3           = $86
.const KEY_F4           = $8A
.const KEY_F5           = $87
.const KEY_F6           = $8B
.const KEY_F7           = $88
.const KEY_F8           = $8C
.const KEY_RETURN       = $0D
.const KEY_RUNSTOP      = $03
.const KEY_UP           = $91
.const KEY_DOWN         = $11
.const KEY_LEFT         = $9D
.const KEY_RIGHT        = $1D
.const KEY_PLUS         = $2B
.const KEY_MINUS        = $2D

// ----------------------------------------------------------------------------
// Music/Synth Constants
// ----------------------------------------------------------------------------
.const NUM_VOICES       = 3
.const NUM_PATCHES      = 128
.const NUM_PATTERNS     = 32
.const PATTERN_LENGTH   = 16
.const NUM_LFOS         = 4

.const MIN_TEMPO        = 20
.const MAX_TEMPO        = 300
.const DEFAULT_TEMPO    = 120

// MIDI Note numbers
.const MIDI_C0          = 0
.const MIDI_C4          = 48
.const MIDI_B7          = 95

// ----------------------------------------------------------------------------
// Patch Data Structure (64 bytes per patch)
// ----------------------------------------------------------------------------
// Offset   Size    Description
// 0-7      8       Patch name (PETSCII)
// 8        1       Voice 1 Waveform
// 9        1       Voice 1 Attack/Decay
// 10       1       Voice 1 Sustain/Release
// 11-12    2       Voice 1 Pulse Width
// 13       1       Voice 1 Octave (-3 to +3)
// 14       1       Voice 1 Fine tune (-128 to +127)
// 15       1       Voice 2 Waveform
// 16       1       Voice 2 Attack/Decay
// 17       1       Voice 2 Sustain/Release
// 18-19    2       Voice 2 Pulse Width
// 20       1       Voice 2 Octave
// 21       1       Voice 2 Fine tune
// 22       1       Voice 3 Waveform
// 23       1       Voice 3 Attack/Decay
// 24       1       Voice 3 Sustain/Release
// 25-26    2       Voice 3 Pulse Width
// 27       1       Voice 3 Octave
// 28       1       Voice 3 Fine tune
// 29       1       Filter Cutoff Low
// 30       1       Filter Cutoff High (3 bits)
// 31       1       Filter Resonance (4 bits)
// 32       1       Filter Mode & Routing
// 33       1       LFO1 Waveform
// 34       1       LFO1 Rate
// 35       1       LFO1 Depth
// 36       1       LFO1 Destination
// 37-40    4       LFO2 settings
// 41-44    4       LFO3 settings
// 45-48    4       LFO4 settings
// 49       1       Arpeggio Mode
// 50       1       Arpeggio Speed
// 51       1       Arpeggio Range
// 52-63    12      Reserved

.const PATCH_SIZE       = 64

// ----------------------------------------------------------------------------
// Pattern Data Structure (256 bytes per pattern)
// ----------------------------------------------------------------------------
// 16 steps × 3 voices × 4 bytes per step = 192 bytes
// Step data format (4 bytes per step):
//   Byte 0: Note (0-95 = MIDI note, 255 = rest, 254 = tie)
//   Byte 1: Velocity (0-255)
//   Byte 2: Gate flags (bit 0=gate, bit 1=accent, bit 2=slide)
//   Byte 3: Waveform override (0=use patch, else waveform)

.const PATTERN_SIZE     = 256
.const STEP_SIZE        = 4
.const STEP_REST        = 255
.const STEP_TIE         = 254

// ----------------------------------------------------------------------------
// Zero Page Variables
// ----------------------------------------------------------------------------
.const ZP_TEMP          = $02       // Temporary variable
.const ZP_TEMP2         = $03       // Temporary variable 2
.const ZP_PTR1          = $04       // General pointer 1 (2 bytes)
.const ZP_PTR2          = $06       // General pointer 2 (2 bytes)
.const ZP_CURRENT_VOICE = $08       // Current voice being processed
.const ZP_CURRENT_STEP  = $09       // Current sequencer step
.const ZP_CURRENT_PATCH = $0A       // Current patch number
.const ZP_IRQ_FLAG      = $0B       // IRQ synchronization flag

// ----------------------------------------------------------------------------
// Color Constants (for UI)
// ----------------------------------------------------------------------------
.const COL_BLACK        = 0
.const COL_WHITE        = 1
.const COL_RED          = 2
.const COL_CYAN         = 3
.const COL_PURPLE       = 4
.const COL_GREEN        = 5
.const COL_BLUE         = 6
.const COL_YELLOW       = 7
.const COL_ORANGE       = 8
.const COL_BROWN        = 9
.const COL_LIGHT_RED    = 10
.const COL_DARK_GREY    = 11
.const COL_GREY         = 12
.const COL_LIGHT_GREEN  = 13
.const COL_LIGHT_BLUE   = 14
.const COL_LIGHT_GREY   = 15

// ----------------------------------------------------------------------------
// PETSCII Characters
// ----------------------------------------------------------------------------
.const CHR_SPACE        = 32
.const CHR_HEART        = 83
.const CHR_DIAMOND      = 90
.const CHR_CLUB         = 88
.const CHR_SPADE        = 85
.const CHR_BALL         = 81
.const CHR_HORIZ        = 64        // Horizontal line
.const CHR_VERT         = 93        // Vertical line
.const CHR_UL_CORNER    = 85        // Upper-left corner
.const CHR_UR_CORNER    = 73        // Upper-right corner
.const CHR_LL_CORNER    = 74        // Lower-left corner
.const CHR_LR_CORNER    = 75        // Lower-right corner
