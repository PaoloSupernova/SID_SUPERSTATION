# SID SUPERSTATION - User Manual

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Synthesizer Controls](#synthesizer-controls)
4. [Pattern Sequencer](#pattern-sequencer)
5. [Patch Management](#patch-management)
6. [Advanced Techniques](#advanced-techniques)
7. [Troubleshooting](#troubleshooting)

---

## Introduction

Welcome to **SID SUPERSTATION**, a comprehensive synthesizer and sequencer for the Commodore 64 that harnesses the full power of the legendary MOS 6581/8580 SID chip. This manual will guide you through all features and help you create amazing sounds.

### What is the SID Chip?

The **Sound Interface Device (SID)** was designed by Bob Yannes and is one of the most iconic sound chips ever created. It features:

- 3 independent oscillators with multiple waveforms
- Ring modulation and hard sync capabilities
- Multi-mode resonant filter
- Full ADSR envelope generators
- 8 octaves of range

---

## Getting Started

### First Boot

When you start SID SUPERSTATION, you'll see the **SYNTH** page with the oscillator controls displayed. The screen shows:

```
╔══════════════════════════════════════╗
║  SID SUPERSTATION v1.0        P:001 ║
╠══════════════════════════════════════╣
║ OSC1:SAW  OSC2:PUL  OSC3:TRI       ║
║ TUNE: +00  +00  +00                ║
║ PW:  0800  0400  0000              ║
║ A:04 D:08 S:12 R:06  [Voice 1]    ║
╠══════════════════════════════════════╣
║ FILTER: LP  CUT:1024 RES:08       ║
║ ROUTE: [1][2][ ]   ENV AMT: +64   ║
╠══════════════════════════════════════╣
║ LFO1:TRI→PITCH  R:32 D:64         ║
║ LFO2:SQR→PW     R:16 D:128        ║
╠══════════════════════════════════════╣
║ ARP:UP  OCT:2  SPD:4              ║
╠══════════════════════════════════════╣
║ F1:OSC F3:FILT F5:LFO F7:SEQ      ║
║ F2:ENV F4:ARP  F6:SAVE F8:LOAD    ║
╚══════════════════════════════════════╝
```

### Playing Your First Note

1. Make sure **piano mode** is enabled (it is by default)
2. Press **Q** on the keyboard - this plays a C note
3. Try other keys: **W** (D), **E** (E), **R** (F), etc.
4. Press **2** for C# (sharp/flat notes)
5. Press **Z** or **X** to change octaves

---

## Synthesizer Controls

### Oscillator Section (F1)

Each of the three voices has independent control over:

#### Waveform Selection
- **TRI** - Triangle wave (smooth, flute-like)
- **SAW** - Sawtooth wave (bright, string-like)
- **PUL** - Pulse wave (variable width, hollow sound)
- **NOI** - Noise (percussion, effects)

**Combinations**: You can combine waveforms for unique timbres!

#### Tuning
- **Octave Shift**: -3 to +3 octaves relative to played note
- **Fine Tune**: -128 to +127 cents for detuning effects

#### Pulse Width (PUL waveform only)
- Range: 0-4095 ($000-$FFF)
- 0% = thin sound, 50% ($800) = square wave, 100% = silence
- **PWM Tip**: Modulate with LFO for classic analog synth sounds

#### Special Features
- **Hard Sync**: Voice 2 can sync to Voice 1, Voice 3 can sync to Voice 2
- **Ring Modulation**: Creates metallic, bell-like tones

---

### Envelope Section (F2)

Each voice has a full **ADSR** envelope that controls volume over time:

#### Attack (0-15)
- Time from note-on to peak volume
- 0 = instant (2ms), 15 = very slow (8 seconds)

#### Decay (0-15)
- Time from peak to sustain level
- Affects how quickly the initial transient fades

#### Sustain (0-15)
- Held volume level while note is pressed
- 0 = silent, 15 = maximum volume

#### Release (0-15)
- Time from note-off to silence
- Controls the "tail" of the sound

**ADSR Tips**:
- **Pluck sounds**: High attack (0-2), fast decay, low sustain, short release
- **Pad sounds**: Slow attack (8-12), slow decay, high sustain, long release
- **Percussive**: Fast attack, fast decay, zero sustain, short release

---

### Filter Section (F3)

The SID chip has one filter that can be routed to any combination of voices.

#### Cutoff Frequency (0-2047)
- Controls which frequencies pass through
- Low values = darker sound, high values = brighter sound

#### Resonance (0-15)
- Emphasizes frequencies near the cutoff
- High values create a "whistling" self-oscillation

#### Filter Types
- **LP** - Low-pass: Removes high frequencies (warm, mellow)
- **BP** - Band-pass: Removes high and low frequencies (hollow, vocal)
- **HP** - High-pass: Removes low frequencies (thin, tinny)
- **Combinations**: LP+BP, LP+HP, BP+HP, LP+BP+HP for unique tones

#### Voice Routing
- Toggle each voice in/out of the filter
- Unfiltered voices bypass the filter entirely
- **Tip**: Filter only bass voice for classic house sound

---

### LFO System (F5)

**LFOs** (Low Frequency Oscillators) add movement and animation to sounds.

#### LFO Parameters
- **Waveform**: Triangle, Sawtooth, Square, Sine, Random
- **Rate**: 0-255 (speed of modulation)
- **Depth**: 0-255 (intensity of modulation)
- **Destination**: What the LFO controls

#### LFO Destinations

**Pitch (Vibrato)**:
- Creates vibrato effect
- Use triangle or sine wave for musical vibrato
- Use random for sci-fi effects

**Pulse Width (PWM)**:
- Creates sweeping, evolving timbres
- Classic analog synth sound
- Use slow triangle wave for pad sounds

**Filter Cutoff**:
- Creates auto-wah effects
- Use sawtooth for classic filter sweeps
- Use envelope-triggered LFO for analog filter envelope

**Volume (Tremolo)**:
- Creates tremolo/amplitude modulation
- Use square wave for rhythmic gating
- Use sine wave for smooth tremolo

---

### Arpeggiator (F4)

The arpeggiator automatically plays sequences of notes.

#### Arpeggio Modes
- **Up**: Plays held notes from low to high
- **Down**: Plays held notes from high to low
- **Up/Down**: Plays up then down (excluding extremes on return)
- **Random**: Plays held notes in random order
- **Played Order**: Plays notes in the order you pressed them

#### Parameters
- **Speed**: 1-16 (tied to sequencer tempo)
- **Range**: 1-4 octaves (repeats pattern across octaves)

**Arp Tips**:
- Hold a chord (3+ notes) for best results
- Try random mode with short notes for IDM-style sequences
- Use with pulse width modulation for evolving arpeggios

---

## Pattern Sequencer

### Sequencer Basics (F7)

The sequencer lets you program rhythmic patterns and melodies.

#### Sequencer Screen
```
╔══════════════════════════════════════╗
║ SEQUENCER  PAT:01  BPM:120  4/4    ║
╠══════════════════════════════════════╣
║ STEP: 01 02 03 04 05 06 07 08      ║
║ V1:   C4 -- E4 -- G4 -- C5 --     ║
║ V2:   C3 C3 C3 C3 E3 E3 G3 G3    ║
║ V3:   C2 -- -- -- C2 -- -- --     ║
║ GATE: ## -- ## -- ## -- ## --      ║
║ ACC:  *  .  .  .  *  .  .  .      ║
╠══════════════════════════════════════╣
║ [PLAY] [STOP] [REC] [EDIT]        ║
╚══════════════════════════════════════╝
```

#### Step Entry
- **Note**: C-0 to B-7, or `--` for rest, `==` for tie
- **Gate**: `##` = note on, `--` = note off
- **Accent**: `*` = accented note (louder), `.` = normal
- **Velocity**: 0-255 (affects volume/filter)

### Transport Controls

- **RUN/STOP key**: Start/stop playback
- **Cursor keys**: Navigate between steps
- **+/-**: Adjust selected parameter
- **RETURN**: Enter/confirm

### Pattern Management

#### Creating Patterns
1. Press F7 to enter sequencer
2. Use cursor keys to select step and voice
3. Enter note data
4. Press RUN/STOP to hear your pattern

#### Copying Patterns
1. Select source pattern
2. Press C (copy)
3. Select destination pattern
4. Press V (paste)

#### Clearing Patterns
1. Select pattern to clear
2. Press SHIFT+C (clear)
3. Confirm with RETURN

### Song Mode

Link patterns together to create complete songs:

1. Enable song mode (SHIFT+S)
2. Enter pattern numbers in song chain (00-31)
3. Set song length (1-64 patterns)
4. Press PLAY to hear full song

**Song Tips**:
- Start with 4-8 bar phrases
- Use pattern variations (copy + modify)
- Build arrangement gradually (intro, verse, chorus, etc.)

---

## Patch Management

### Saving Patches (F6)

1. Press F6 to enter save page
2. Enter filename (up to 8 characters)
3. Select file type:
   - **Single Patch** (.pat)
   - **Pattern** (.seq)
   - **Full Bank** (.bnk)
   - **Song** (.sng)
4. Press RETURN to save

### Loading Patches (F8)

1. Press F8 to enter load page
2. Navigate file list with cursor keys
3. Select file
4. Press RETURN to load

### Patch Organization Tips

- Use descriptive 8-char names (BASSLEAD, PADSWEP1, etc.)
- Save variations of good patches
- Create patch banks organized by type (BASS.BNK, LEADS.BNK)
- Back up to separate disks regularly

---

## Advanced Techniques

### Creating Classic Sounds

#### TB-303 Style Bass
1. Voice 1: Sawtooth wave
2. Attack: 0, Decay: 4, Sustain: 0, Release: 2
3. Filter: Low-pass, cutoff ~600, resonance ~12
4. LFO1: Envelope → Filter cutoff, rate: 8, depth: 128
5. Use sequencer with accent and slide

#### Lush String Pad
1. Voice 1: Sawtooth, octave: 0
2. Voice 2: Sawtooth, octave: 0, detune: +7
3. Voice 3: Triangle, octave: +1
4. Attack: 10, Decay: 4, Sustain: 12, Release: 10
5. Filter: Low-pass, cutoff: 1200, resonance: 4
6. LFO1: Triangle → Pitch, rate: 2, depth: 16 (vibrato)
7. LFO2: Triangle → Pulse width V1+V2, rate: 8, depth: 64

#### Punchy Bass Drum
1. Voice 3: Triangle
2. Attack: 0, Decay: 8, Sustain: 0, Release: 0
3. LFO1: Decay envelope → Pitch, rate: 0, depth: 255
4. Start note at C2, pitch sweeps down

#### Snare Drum
1. Voice 3: Noise
2. Attack: 0, Decay: 6, Sustain: 0, Release: 2
3. Filter: Band-pass, cutoff: 1400, resonance: 8
4. Add short click on Voice 1 (pulse, very short envelope)

### Modulation Tricks

**Pseudo-Reverb**:
- Use Voice 3 delayed copy of Voice 1
- Lower volume, short delay
- Add slight detuning

**Stereo Width** (when recording):
- Record Voice 1 + Voice 2 panned left
- Record Voice 3 panned right
- Use slight detuning between voices

**Filter Sweeps**:
- LFO to filter cutoff with slow triangle wave
- High resonance for dramatic effect
- Try different filter modes during sweep

---

## Troubleshooting

### Common Issues

**No Sound**:
- Check master volume ($D418 register)
- Verify gate bit is set (note is being triggered)
- Check filter routing (voices might be filtered with cutoff at 0)
- Ensure ADSR envelope has sustain > 0

**Distorted/Harsh Sound**:
- Lower filter resonance
- Reduce pulse width extremes
- Check for ring mod or sync enabled unintentionally

**Sequencer Not Playing**:
- Press RUN/STOP to start
- Check pattern has note data (not all rests)
- Verify tempo is reasonable (20-300 BPM)

**Patches Won't Save**:
- Check disk drive is connected and powered
- Verify disk has write-protect tab open
- Ensure disk has free space
- Check filename is valid (no special characters)

**Keyboard Not Responding**:
- Piano mode might be disabled
- Wrong octave range (press Z or X to shift)
- Check if stuck in edit mode (press RUN/STOP to exit)

### Getting Help

If you encounter bugs or have questions:
1. Check this manual thoroughly
2. Review example patches
3. Open an issue on GitHub
4. Join the community forums

---

## Appendix: Quick Reference

### Keyboard Shortcuts
| Key | Function |
|-----|----------|
| F1-F8 | Switch pages |
| RUN/STOP | Start/stop sequencer |
| Cursor keys | Navigate |
| +/- | Adjust value |
| Q-P | White piano keys |
| 2-0 | Black piano keys |
| Z | Octave down |
| X | Octave up |

### Parameter Ranges
| Parameter | Range | Notes |
|-----------|-------|-------|
| ADSR | 0-15 each | Non-linear timing |
| Filter Cutoff | 0-2047 | 11-bit value |
| Resonance | 0-15 | 4-bit value |
| Pulse Width | 0-4095 | 12-bit value |
| LFO Rate | 0-255 | 8-bit value |
| LFO Depth | 0-255 | 8-bit value |
| Tempo | 20-300 | BPM |

---

**End of User Manual**

For more technical information, see:
- [SID Registers Reference](SID_REGISTERS.md)
- [Keyboard Map](KEYBOARD_MAP.md)
- [Audio Connection Guide](AUDIO_CONNECTION.md)
