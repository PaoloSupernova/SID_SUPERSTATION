```
  _____ _____ _____    _____ _    _ _____  ______ _____   _____ _______    _______ _____ ____  _   _ 
 / ____|_   _|  __ \  / ____| |  | |  __ \|  ____|  __ \ / ____|__   __|/\|__   __|_   _/ __ \| \ | |
| (___   | | | |  | || (___ | |  | | |__) | |__  | |__) | (___    | |  /  \  | |    | || |  | |  \| |
 \___ \  | | | |  | | \___ \| |  | |  ___/|  __| |  _  / \___ \   | | / /\ \ | |    | || |  | | . ` |
 ____) |_| |_| |__| | ____) | |__| | |    | |____| | \ \ ____) |  | |/ ____ \| |   _| || |__| | |\  |
|_____/|_____|_____/ |_____/ \____/|_|    |______|_|  \_\_____/   |_/_/    \_\_|  |_____\____/|_| \_|
```

# SID SUPERSTATION v1.0

**A comprehensive Commodore 64 SID chip synthesizer and sequencer**  
*Inspired by the Elektron SIDstation*

Transform your Commodore 64 into a powerful hardware synthesizer utilizing the legendary MOS 6581/8580 SID chip. Connect directly to your DAW, mixer, or recording gear via the C64's audio output jack.

---

## 🎹 Features

### Synthesizer Engine
- **3-Voice Polyphony** with full control over each voice
- **Multiple Waveforms**: Triangle, Sawtooth, Pulse, Noise, and combinations
- **Full ADSR Envelopes** for each voice (Attack, Decay, Sustain, Release)
- **Pulse Width Modulation** with manual control
- **Hard Sync** and **Ring Modulation** between oscillators
- **Octave Shifting** (-3 to +3 octaves per voice)
- **Fine Tuning** for detuning and microtuning effects

### Filter Section
- **11-bit Cutoff Frequency** control (0-2047)
- **4-bit Resonance** control (0-15)
- **Multiple Filter Types**: Low-pass, Band-pass, High-pass, and combinations
- **Per-Voice Filter Routing** - route any combination of voices through the filter
- **Filter Envelope** - software-driven filter sweeps via LFO modulation

### LFO System
- **4 Software LFOs** with assignable destinations
- **5 LFO Waveforms**: Triangle, Sawtooth, Square, Sine, Random/S&H
- **Flexible Routing**: Pitch (vibrato), Pulse Width (PWM), Filter Cutoff, Volume (tremolo)
- **Rate Control**: 0-255 with optional tempo sync
- **Depth Control**: 0-255 for modulation intensity

### Arpeggiator
- **5 Arpeggio Modes**: Up, Down, Up/Down, Random, Played Order
- **Tempo-Synced** arpeggio speed
- **Arpeggio Range**: 1-4 octaves
- **Custom Pattern Editor**: Create up to 16-step arpeggio patterns

### Pattern Sequencer
- **16-Step Sequencer** (expandable to 32/64 via pattern chaining)
- **3 Tracks** (one per SID voice)
- **Per-Step Parameters**: Note, Gate, Velocity, Waveform override, Accent, Slide
- **32 Patterns** with full copy/paste/clear functions
- **Song Mode**: Chain up to 64 patterns
- **Tempo Control**: 20-300 BPM
- **Swing**: 0-100% swing amount

### Patch System
- **128 Patch Memory Slots**
- **Disk Save/Load**: Save patches, patterns, and complete songs to 1541 disk
- **8-Character Patch Names**
- **Factory Presets** included

### User Interface
- **PETSCII Character-Based UI** - clear, efficient layout
- **Multiple Pages**: Synth, Sequencer, Filter, LFO, Arpeggiator, Save/Load
- **Piano Keyboard Mode** - play the C64 keyboard like a piano (2 octaves)
- **Function Keys** for quick page navigation (F1-F8)
- **Real-Time Parameter Control** with cursor keys and +/- keys

---

## 🎮 Quick Start

### Hardware Requirements
- **Commodore 64** (PAL or NTSC)
- **1541 Disk Drive** (or SD2IEC, 1541 Ultimate) for save/load
- **Audio Cable**: C64 A/V port → mixer/audio interface

### Loading the Program
1. **Using VICE Emulator**:
   ```
   x64 sid_superstation.prg
   ```

2. **On Real Hardware**:
   - Transfer `sid_superstation.prg` to disk
   - Load with: `LOAD "SID_SUPERSTATION",8,1`
   - Run with: `RUN`

### First Steps
1. The synth starts on the **SYNTH** page showing oscillator controls
2. Press **F7** to switch to the **SEQUENCER** page
3. Press **RUN/STOP** to start/stop playback
4. Use **F1-F8** to navigate between pages
5. Play notes using the keyboard (see keyboard map below)

---

## ⌨️ Keyboard Controls

### Function Keys
- **F1** - Oscillator page
- **F2** - Envelope page
- **F3** - Filter page
- **F4** - Arpeggiator page
- **F5** - LFO page
- **F6** - Save page
- **F7** - Sequencer page
- **F8** - Load page

### Transport Controls
- **RUN/STOP** - Start/stop sequencer playback
- **Cursor Keys** - Navigate UI parameters
- **+/-** - Increment/decrement selected parameter
- **RETURN** - Confirm/enter selection

### Piano Keyboard Mode
Play the C64 keyboard like a musical keyboard:

**White Keys (Natural Notes)**:
```
Q W E R T Y U I O P
C D E F G A B C D E
```

**Black Keys (Sharps/Flats)**:
```
2 3   5 6 7   9 0
C# D# F# G# A# C# D#
```

**Octave Control**:
- **Z** - Octave down
- **X** - Octave up

---

## 🔊 Connecting to Your DAW

### Hardware Connection
1. **C64 A/V Port** → **RCA to 3.5mm/1/4" adapter** → **Audio Interface Line In**

### Recommended Setup
- **Gain Staging**: Start with low input gain, adjust to avoid clipping
- **Grounding**: Use proper shielding to minimize noise and hum
- **Recording Tips**: 
  - The SID chip has a characteristic sound - some noise is normal
  - 6581 (older) has a "warmer" sound with more filter distortion
  - 8580 (newer) has a "cleaner" sound with less filter self-oscillation

### DAW Configuration
- **Sample Rate**: 44.1kHz or 48kHz recommended
- **Bit Depth**: 24-bit for best dynamic range
- **Monitoring**: Enable input monitoring to hear while playing
- **Latency**: Use ASIO (Windows) or CoreAudio (Mac) for low latency

---

## 📁 File Formats

### Patch Files (`.pat`)
- Single patch (68 bytes: 4-byte header + 64-byte patch data)
- Header: "SID" + 'P'

### Pattern Files (`.seq`)
- Single pattern (260 bytes: 4-byte header + 256-byte pattern data)
- Header: "SID" + 'S'

### Patch Bank Files (`.bnk`)
- All 128 patches (8KB + header)
- Header: "SID" + 'B'

### Song Files (`.sng`)
- Complete song (patterns + chain + patches)
- Header: "SID" + 'G'

---

## 🏗️ Building from Source

### Prerequisites
- **KickAssembler** (Java-based 6502 assembler)
- **Java Runtime Environment** (JRE 8 or later)
- **VICE Emulator** (for testing)

### Build Instructions
```bash
# Clone the repository
git clone https://github.com/PaoloSupernova/SID_SUPERSTATION.git
cd SID_SUPERSTATION

# Build the program
make

# Run in VICE emulator
make run

# Clean build artifacts
make clean
```

### Build Output
- `build/sid_superstation.prg` - Compiled C64 program

---

## 📚 Documentation

- **[User Manual](docs/USER_MANUAL.md)** - Complete guide to all features
- **[SID Registers Reference](docs/SID_REGISTERS.md)** - Technical SID chip documentation
- **[Keyboard Map](docs/KEYBOARD_MAP.md)** - Complete keyboard layout reference
- **[Audio Connection Guide](docs/AUDIO_CONNECTION.md)** - Detailed connection instructions

---

## 🎨 Architecture

### Memory Map
```
$0800-$3FFF  Main program code (~14KB)
$4000-$5FFF  Patch storage (128 patches × 64 bytes = 8KB)
$6000-$7FFF  Pattern storage (32 patterns × 256 bytes = 8KB)
$8000-$9FFF  Frequency tables and LFO waveforms
$C000-$CFFF  UI buffers
$D400-$D41C  SID chip registers (hardware)
```

### Code Structure
```
src/
├── main.asm           - Entry point and main loop
├── constants.asm      - System constants and memory map
├── tables.asm         - Frequency and waveform tables
├── sid.asm            - Low-level SID chip control
├── synth_engine.asm   - Synthesis engine (LFOs, envelopes, arp)
├── sequencer.asm      - Pattern sequencer and song mode
├── ui.asm             - PETSCII user interface
├── input.asm          - Keyboard and joystick input
└── storage.asm        - Disk I/O for save/load
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

### Areas for Contribution
- Additional factory patches
- UI improvements
- Documentation enhancements
- Bug fixes and optimizations
- Additional LFO destinations
- MIDI support (via user port)

---

## 📜 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2026 SID SUPERSTATION

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Credits

- **Inspired by**: Elektron SIDstation hardware synthesizer
- **SID Chip**: Designed by Bob Yannes at MOS Technology
- **Commodore 64**: Released by Commodore International in 1982

---

## 📧 Contact

For questions, suggestions, or bug reports, please open an issue on GitHub.

---

**🎵 Happy synthesizing! 🎵**