# SID Chip Register Reference

## Overview

The **MOS 6581/8580 SID** (Sound Interface Device) chip is memory-mapped at addresses `$D400-$D41C` in the Commodore 64. This document provides a complete reference to all SID registers.

---

## Register Map

| Address | Register | Description |
|---------|----------|-------------|
| $D400 | V1_FREQ_LO | Voice 1 Frequency Low Byte |
| $D401 | V1_FREQ_HI | Voice 1 Frequency High Byte |
| $D402 | V1_PW_LO | Voice 1 Pulse Width Low Byte |
| $D403 | V1_PW_HI | Voice 1 Pulse Width High Byte (4 bits) |
| $D404 | V1_CONTROL | Voice 1 Control Register |
| $D405 | V1_AD | Voice 1 Attack/Decay |
| $D406 | V1_SR | Voice 1 Sustain/Release |
| $D407 | V2_FREQ_LO | Voice 2 Frequency Low Byte |
| $D408 | V2_FREQ_HI | Voice 2 Frequency High Byte |
| $D409 | V2_PW_LO | Voice 2 Pulse Width Low Byte |
| $D40A | V2_PW_HI | Voice 2 Pulse Width High Byte (4 bits) |
| $D40B | V2_CONTROL | Voice 2 Control Register |
| $D40C | V2_AD | Voice 2 Attack/Decay |
| $D40D | V2_SR | Voice 2 Sustain/Release |
| $D40E | V3_FREQ_LO | Voice 3 Frequency Low Byte |
| $D40F | V3_FREQ_HI | Voice 3 Frequency High Byte |
| $D410 | V3_PW_LO | Voice 3 Pulse Width Low Byte |
| $D411 | V3_PW_HI | Voice 3 Pulse Width High Byte (4 bits) |
| $D412 | V3_CONTROL | Voice 3 Control Register |
| $D413 | V3_AD | Voice 3 Attack/Decay |
| $D414 | V3_SR | Voice 3 Sustain/Release |
| $D415 | FC_LO | Filter Cutoff Frequency Low Byte (3 bits) |
| $D416 | FC_HI | Filter Cutoff Frequency High Byte |
| $D417 | RES_FILT | Resonance & Filter Routing |
| $D418 | MODE_VOL | Filter Mode & Master Volume |
| $D419 | POTX | Paddle X Position (Read Only) |
| $D41A | POTY | Paddle Y Position (Read Only) |
| $D41B | OSC3 | Voice 3 Oscillator Output (Read Only) |
| $D41C | ENV3 | Voice 3 Envelope Output (Read Only) |

---

## Detailed Register Descriptions

### Voice Frequency Registers ($D400-$D401, $D407-$D408, $D40E-$D40F)

**16-bit frequency value** (little-endian: low byte first, high byte second)

**Formula**: `frequency_hz = (freq_value * clock_rate) / 16777216`

Where:
- `freq_value` = 16-bit value in frequency registers
- `clock_rate` = 985248 Hz (PAL) or 1022727 Hz (NTSC)

**Example**: Middle C (261.63 Hz) on PAL:
```
freq_value = (261.63 * 16777216) / 985248 ≈ 4459 ($116B)
$D400 = $6B (low byte)
$D401 = $11 (high byte)
```

---

### Pulse Width Registers ($D402-$D403, $D409-$D40A, $D410-$D411)

**12-bit pulse width value** (only lower 4 bits of high byte are used)

**Range**: 0-4095 ($000-$FFF)

**Behavior**:
- 0 = 0% duty cycle (thinnest pulse)
- 2048 ($800) = 50% duty cycle (square wave)
- 4095 ($FFF) = ~100% duty cycle (nearly silent)

**Note**: Pulse width only affects pulse waveform. Other waveforms ignore this setting.

**Example**: 25% duty cycle
```
pulse_value = 1024 ($400)
$D402 = $00 (low byte)
$D403 = $04 (high byte)
```

---

### Control Registers ($D404, $D40B, $D412)

**Bit Layout**:
```
Bit 7: Noise waveform select
Bit 6: Pulse waveform select
Bit 5: Sawtooth waveform select
Bit 4: Triangle waveform select
Bit 3: Test bit (resets oscillator)
Bit 2: Ring modulation enable
Bit 1: Hard sync enable
Bit 0: Gate bit (trigger envelope)
```

**Waveform Selection** (Bits 7-4):
- Multiple waveforms can be enabled simultaneously
- Common combinations:
  - `%00010000` ($10) - Triangle only
  - `%00100000` ($20) - Sawtooth only
  - `%01000000` ($40) - Pulse only
  - `%10000000` ($80) - Noise only
  - `%01010000` ($50) - Pulse + Triangle
  - `%01100000` ($60) - Pulse + Sawtooth

**Gate Bit** (Bit 0):
- 0 = Note off (triggers release phase)
- 1 = Note on (triggers attack phase)

**Hard Sync** (Bit 1):
- Voice 1 can sync Voice 2
- Voice 2 can sync Voice 3
- Synchronized voice resets when sync source crosses zero
- Creates harmonic-rich timbres

**Ring Modulation** (Bit 2):
- Voice 1 ring mods Voice 2
- Voice 2 ring mods Voice 3
- Triangle waveform only
- Creates inharmonic, bell-like tones

**Test Bit** (Bit 3):
- Resets oscillator to zero and halts
- Used for special effects or initialization
- Must be cleared to resume normal operation

---

### Attack/Decay Registers ($D405, $D40C, $D413)

**Bit Layout**:
```
Bits 7-4: Attack rate (0-15)
Bits 3-0: Decay rate (0-15)
```

**Attack Times** (approximate):
```
0: 2ms      4: 38ms     8: 100ms    12: 1000ms
1: 8ms      5: 56ms     9: 250ms    13: 3000ms
2: 16ms     6: 68ms     10: 500ms   14: 5000ms
3: 24ms     7: 80ms     11: 800ms   15: 8000ms
```

**Decay Times**: Same as attack times

**Example**: Fast attack (2), medium decay (8)
```
$D405 = $28  (%00101000)
```

---

### Sustain/Release Registers ($D406, $D40D, $D414)

**Bit Layout**:
```
Bits 7-4: Sustain level (0-15)
Bits 3-0: Release rate (0-15)
```

**Sustain Level**:
- 0 = Silent
- 15 = Maximum volume
- Linear scale

**Release Times**: Same as attack/decay times

**Example**: High sustain (12), short release (4)
```
$D406 = $C4  (%11000100)
```

---

### Filter Cutoff Registers ($D415-$D416)

**11-bit cutoff frequency** (3 bits in $D415, 8 bits in $D416)

**Register Layout**:
```
$D415 (bits 2-0): Cutoff low 3 bits
$D416 (bits 7-0): Cutoff high 8 bits
```

**Range**: 0-2047 ($000-$7FF)

**Frequency Response**:
- 0 = Lowest cutoff (~30 Hz)
- 2047 = Highest cutoff (~12 kHz)
- Response is roughly exponential

**Example**: Cutoff at 1024
```
$D415 = $00  (low 3 bits = 000)
$D416 = $80  (high 8 bits = 10000000)
```

---

### Resonance & Filter Routing Register ($D417)

**Bit Layout**:
```
Bits 7-4: Resonance (0-15)
Bit 3: Filter external input
Bit 2: Filter voice 3
Bit 1: Filter voice 2
Bit 0: Filter voice 1
```

**Resonance**:
- 0 = No resonance
- 15 = Maximum resonance (self-oscillation)
- Emphasizes frequencies near cutoff

**Filter Routing** (Bits 2-0):
- 0 = Voice not filtered
- 1 = Voice routed through filter
- Can filter any combination of voices

**Example**: Resonance 8, filter voices 1 and 2
```
$D417 = $83  (%10000011)
```

---

### Filter Mode & Volume Register ($D418)

**Bit Layout**:
```
Bit 7: Disconnect voice 3 output
Bit 6: High-pass filter enable
Bit 5: Band-pass filter enable
Bit 4: Low-pass filter enable
Bits 3-0: Master volume (0-15)
```

**Filter Modes**:
- `%00010000` ($10) - Low-pass only
- `%00100000` ($20) - Band-pass only
- `%01000000` ($40) - High-pass only
- `%00110000` ($30) - Low-pass + Band-pass (Notch)
- `%01010000` ($50) - Low-pass + High-pass (Band-reject)
- `%01100000` ($60) - Band-pass + High-pass
- `%01110000` ($70) - All three modes

**Voice 3 Disconnect** (Bit 7):
- When set, Voice 3 is removed from audio output
- Useful for using Voice 3 as LFO source
- Voice 3 can still be read via $D41B/$D41C

**Master Volume** (Bits 3-0):
- 0 = Silent
- 15 = Maximum volume
- Affects all voices equally

**Example**: Low-pass filter, volume 12
```
$D418 = $1C  (%00011100)
```

---

## Read-Only Registers

### Paddle Registers ($D419-$D41A)

**POTX/POTY**: 8-bit paddle position values

Used for paddle controllers, not typically used in synthesizer applications.

### Oscillator 3 Output ($D41B)

**OSC3**: Current output of Voice 3 oscillator (8-bit)

- Useful for reading waveforms as LFO source
- Updates continuously as oscillator runs
- Can be used for random number generation (noise waveform)

### Envelope 3 Output ($D41C)

**ENV3**: Current output of Voice 3 envelope (8-bit)

- Useful for reading envelope as modulation source
- Updates as envelope progresses through ADSR stages
- Can trigger events based on envelope position

---

## SID Chip Differences

### 6581 (Original)
- "Warmer" sound
- More filter distortion
- Better self-oscillation
- Slight DC offset
- Combined waveforms sound different

### 8580 (Revised)
- "Cleaner" sound
- Less filter distortion
- Weaker self-oscillation
- No DC offset
- Combined waveforms sound different
- Some noise artifacts at low frequencies

**Note**: SID SUPERSTATION is designed to work with both chip revisions, but sounds may vary slightly between them.

---

## Programming Tips

### Frequency Calculation
```
C64 Basic frequency calculation:
freq_value = (desired_hz * 16777216) / 985248

Assembly pseudocode:
1. Look up pre-calculated value in frequency table
2. Write low byte to $D400 (or $D407/$D40E)
3. Write high byte to $D401 (or $D408/$D40F)
```

### Smooth Parameter Changes
- Change parameters over multiple frames for smooth transitions
- Use LFO for continuous modulation
- Ramp filter cutoff gradually for sweeps

### Avoiding Clicks
- Always set gate bit to 0 before changing waveform
- Use short attack time for percussive sounds
- Use release time > 0 to avoid hard cutoffs

### CPU Load Considerations
- Minimize register writes (only update when needed)
- Use raster interrupts for time-critical updates
- Pre-calculate values when possible

---

## Common Recipes

### Basic Note Trigger
```asm
LDA #$09        ; Attack=0, Decay=9
STA $D405       ; Voice 1 A/D
LDA #$00        ; Sustain=0, Release=0
STA $D406       ; Voice 1 S/R
LDA #$21        ; Sawtooth + Gate on
STA $D404       ; Voice 1 Control
; ... (after note duration)
LDA #$20        ; Sawtooth + Gate off
STA $D404       ; Voice 1 Control
```

### Filter Sweep
```asm
; Initialize
LDA #$10        ; Low-pass filter
STA $D418
; In interrupt routine:
INC $D416       ; Increment cutoff high byte
BNE skip
INC $D415       ; Increment cutoff low byte
AND #$07        ; Keep in 11-bit range
STA $D415
skip:
```

---

## References

- [SID Chip Datasheet](http://www.sidmusic.org/sid/sidtech.html)
- [C64 Programmer's Reference Guide](https://www.c64-wiki.com/)
- [SID Music Archive](http://www.hvsc.c64.org/)

---

**For SID SUPERSTATION implementation details, see `src/sid.asm` in the source code.**
