# Build and Test Guide

## Prerequisites

### Required Software

1. **KickAssembler** (6502 assembler)
   - Download from: http://theweb.dk/KickAssembler/
   - Requires Java Runtime Environment (JRE) 8 or later
   - Extract and note the path to `KickAss.jar`

2. **VICE Emulator** (for testing)
   - Download from: https://vice-emu.sourceforge.io/
   - Available for Windows, macOS, and Linux
   - Provides accurate C64 emulation

3. **Python 3** (for frequency table generation)
   - Usually pre-installed on macOS/Linux
   - Windows: Download from https://www.python.org/

### Optional Software

- **C64 Debugger** - Advanced debugging: http://c64-debugger.com/
- **sd2iec** firmware - For real hardware transfer: https://www.sd2iec.de/

---

## Building the Project

### Method 1: Using Make (Recommended)

**Prerequisites**: 
- KickAssembler installed and `KickAss.jar` accessible
- Java in PATH

**Edit Makefile** if KickAss.jar is not in PATH:
```makefile
ASM = java -jar /path/to/KickAss.jar
```

**Build Commands**:
```bash
# Build the program
make

# Clean build artifacts
make clean

# Generate frequency table (if needed)
make freqtable

# Build and run in VICE
make run
```

### Method 2: Manual Build

If Make is not available:

```bash
# Create build directory
mkdir -p build

# Assemble the program
java -jar KickAss.jar -o build/sid_superstation.prg src/main.asm

# Run in VICE emulator
x64 build/sid_superstation.prg
```

### Method 3: Using the Build Script

```bash
# Make script executable
chmod +x tools/build.sh

# Run build
./tools/build.sh

# Run with emulator
./tools/build.sh run
```

---

## Testing in VICE Emulator

### Starting VICE

**Command Line**:
```bash
x64 build/sid_superstation.prg
```

**GUI Method**:
1. Launch VICE (x64)
2. File → Autostart Disk/Tape Image
3. Select `build/sid_superstation.prg`
4. Press RETURN to start

### VICE Configuration

**Recommended Settings**:

1. **Machine Settings** (Settings → Machine Settings):
   - Model: C64 PAL
   - SID Engine: ReSID
   - SID Model: 6581 or 8580 (test both)

2. **Audio Settings** (Settings → Sound Settings):
   - Sample Rate: 48000 Hz
   - Buffer Size: 50ms (adjust for latency)
   - Enable sound

3. **Video Settings** (Settings → Video Settings):
   - Render filter: None (for crisp PETSCII)
   - Size: 2x or 3x

### VICE Keyboard Mapping

VICE maps host keyboard to C64 keyboard. Common mappings:

| C64 Key | PC Key | Mac Key |
|---------|--------|---------|
| RUN/STOP | ESC | ESC |
| F1 | F1 | F1 |
| F3 | F3 | F3 |
| F5 | F5 | F5 |
| F7 | F7 | F7 |

**Enable Positional Mapping**: Settings → Keyboard → Positional

---

## Testing Checklist

### Basic Functionality Tests

- [ ] **Program Loads**: Program starts without errors
- [ ] **UI Displays**: Screen shows synthesizer interface
- [ ] **Keyboard Input**: Function keys switch pages
- [ ] **Piano Mode**: Keys Q-P produce sound
- [ ] **Octave Shift**: Z/X change octave
- [ ] **Parameter Edit**: +/- change values
- [ ] **Sequencer**: RUN/STOP starts/stops playback

### Audio Tests

- [ ] **Voice 1**: Press Q (should hear C note)
- [ ] **Voice 2**: Load patch with Voice 2, test sound
- [ ] **Voice 3**: Load patch with Voice 3, test sound
- [ ] **Waveforms**: Test Triangle, Sawtooth, Pulse, Noise
- [ ] **Filter**: Adjust filter cutoff, hear change
- [ ] **ADSR**: Modify envelope, hear difference

### Feature Tests

- [ ] **LFO**: Enable LFO, hear modulation
- [ ] **Arpeggiator**: Enable arp, hold chord
- [ ] **Sequencer**: Program pattern, plays back correctly
- [ ] **Pattern Copy**: Copy pattern works
- [ ] **Patch Save/Load**: Save/load operations work

### Regression Tests

- [ ] **Tempo Changes**: Change tempo, verify accuracy
- [ ] **Multiple Voices**: Play 3 voices simultaneously
- [ ] **Filter Routing**: Route different voice combinations
- [ ] **Page Switching**: All pages load without crashes

---

## Recording Audio from VICE

### Method 1: VICE Built-in Recording

1. **Start Recording**:
   - File → Sound Recording → Start
   - Choose format (WAV recommended)
   - Select output file

2. **Play Music**: Perform or play sequence

3. **Stop Recording**: File → Sound Recording → Stop

### Method 2: System Audio Capture

**Windows**:
- Use Audacity with WASAPI loopback
- Stereo Mix device in Sound settings

**macOS**:
- Use Soundflower + DAW
- BlackHole virtual audio device

**Linux**:
- Use PulseAudio loopback
- Jack audio system

---

## Troubleshooting Build Issues

### KickAssembler Not Found

**Error**: `java: command not found` or `KickAss.jar: not found`

**Solution**:
```bash
# Check Java installation
java -version

# Install Java if needed
# Ubuntu/Debian: sudo apt install default-jre
# macOS: brew install java
# Windows: Download from java.com

# Verify KickAss.jar path
ls -l /path/to/KickAss.jar

# Update Makefile with correct path
```

### Syntax Errors During Assembly

**Error**: `Syntax error` or `Undefined label`

**Common Causes**:
- Missing semicolon in comment
- Typo in label name
- Missing `.import` or `#import` statement

**Solution**:
- Check line number in error message
- Verify syntax against working examples
- Check all labels are defined

### Program Crashes on Load

**Error**: VICE shows `?SYNTAX ERROR` or crashes

**Possible Causes**:
- Incorrect memory address
- Missing BASIC header
- Code overlaps with system memory

**Solution**:
- Verify `.pc = $0801` in main.asm
- Check memory map doesn't overlap ROM
- Review constants.asm memory layout

---

## Running on Real Hardware

### Transfer Methods

**1. SD2IEC** (Recommended):
- Copy `sid_superstation.prg` to SD card
- Insert in SD2IEC device
- Load with: `LOAD "SID_SUPERSTATION",8,1` then `RUN`

**2. 1541 Ultimate**:
- Copy .prg via USB or network
- Mount as disk image
- Load normally

**3. EasyFlash**:
- Create cartridge image
- Flash to EasyFlash cartridge
- Instant-on capability

**4. Original 1541 Drive**:
- Use disk imaging software (DirMaster, CBM Transfer)
- Copy to real floppy disk
- Load from disk

### Real Hardware Considerations

**PAL vs NTSC**:
- Program detects system type automatically
- Timing may vary slightly between versions
- Test on actual hardware if available

**SID Chip Revision**:
- 6581 vs 8580 sound different
- Both supported, but patches may need tweaking
- Test with target chip revision

**Power Supply**:
- Ensure stable, clean power
- Audio quality affected by power supply quality
- Consider power supply upgrade for best audio

---

## Debugging Tips

### VICE Debugger

**Activate Monitor**: Alt+H (or File → Activate Monitor)

**Useful Commands**:
```
> d $0800          ; Disassemble at $0800
> m $d400          ; Memory dump at $D400 (SID)
> r                ; Show registers
> break $0810      ; Set breakpoint at $0810
> g                ; Continue (Go)
> z                ; Step instruction
```

### Common Issues

**No Sound**:
- Check `$D418` (should have volume > 0)
- Verify gate bit set in control register
- Check ADSR values (sustain > 0)

**Timing Issues**:
- Verify CIA timer configuration
- Check interrupt handler is installed
- Ensure raster interrupt is working

**Crashed System**:
- Check for infinite loops
- Verify stack not corrupted
- Check zero page usage doesn't conflict

---

## Performance Optimization

### Profiling

1. Use VICE monitor to count cycles
2. Identify hot spots (interrupt handler, UI update)
3. Optimize critical sections

### Tips

- Pre-calculate values in tables
- Use lookup tables instead of multiplication
- Minimize register writes to SID
- Batch UI updates (don't redraw every frame)

---

## Continuous Integration

### Automated Build Testing

Create `.github/workflows/build.yml`:

```yaml
name: Build SID SUPERSTATION

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Java
        uses: actions/setup-java@v2
        with:
          java-version: '11'
      - name: Download KickAssembler
        run: |
          wget http://www.theweb.dk/KickAssembler/KickAssembler.zip
          unzip KickAssembler.zip
      - name: Build
        run: java -jar KickAss.jar src/main.asm -o sid_superstation.prg
      - name: Upload artifact
        uses: actions/upload-artifact@v2
        with:
          name: sid-superstation
          path: sid_superstation.prg
```

---

## Next Steps

After successful build and test:

1. **Create Demo Patches**: Design example patches showcasing features
2. **Record Demo Video**: Show synthesizer in action
3. **Community Testing**: Share with C64 community for feedback
4. **Hardware Testing**: Test on real C64 hardware
5. **Optimization**: Profile and optimize performance
6. **Documentation**: Add more examples and tutorials

---

## Resources

### Documentation
- [C64 Programmer's Reference](https://www.c64-wiki.com/wiki/C64-Programmer%27s_Reference_Guide)
- [SID Chip Datasheet](http://www.sidmusic.org/sid/sidtech2.html)
- [6502 Instruction Set](http://www.6502.org/tutorials/6502opcodes.html)

### Tools
- [VICE Emulator Manual](https://vice-emu.sourceforge.io/vice_toc.html)
- [KickAssembler Documentation](http://www.theweb.dk/KickAssembler/webhelp/)
- [C64 Debugger](http://c64-debugger.com/)

### Communities
- [Lemon64 Forums](https://www.lemon64.com/forum/)
- [CSDb (C64 Scene Database)](https://csdb.dk/)
- [AtariAge C64 Forum](https://atariage.com/forums/forum/76-commodore-64/)

---

**Happy Building! 🎹🎵**
