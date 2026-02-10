# Audio Connection Guide

## Overview

This guide explains how to connect your Commodore 64 running SID SUPERSTATION to external audio equipment for recording and live performance.

---

## Understanding C64 Audio Output

### Audio Output Specifications

The Commodore 64 provides audio output through its A/V port:

**Output Type**: Composite Video + Audio (8-pin DIN connector)

**Audio Specifications**:
- **Signal Type**: Line-level, composite mono audio
- **Output Impedance**: ~1kΩ
- **Output Level**: ~1V peak-to-peak (approximately -10dBV)
- **Frequency Response**: ~30Hz - 12kHz (limited by SID chip)
- **Signal-to-Noise Ratio**: ~50-60dB (varies by chip revision and modifications)

### SID Chip Audio Characteristics

**6581 (Original)**:
- Warmer, slightly distorted sound
- Better filter self-oscillation
- More character and "vintage" sound
- Slight DC offset may cause clicks

**8580 (Revised)**:
- Cleaner, more precise sound
- Less filter distortion
- Reduced self-oscillation
- No DC offset

---

## Basic Connection Setup

### Required Equipment

1. **C64 A/V Cable** (8-pin DIN to RCA connectors)
2. **Audio Interface** (with line-level inputs)
3. **Cables**:
   - RCA to 3.5mm (1/8") adapter, OR
   - RCA to 1/4" (6.35mm) adapter, OR
   - RCA to RCA cable + interface with RCA inputs

### Simple Connection Chain

```
┌─────────────┐      ┌──────────────┐      ┌──────────┐      ┌──────────┐
│ Commodore   │      │   RCA to     │      │  Audio   │      │   DAW    │
│    64       │──────│   Adapter    │──────│Interface │──────│Computer  │
│  A/V Port   │      │              │      │          │      │          │
└─────────────┘      └──────────────┘      └──────────┘      └──────────┘
```

---

## Step-by-Step Connection

### Step 1: Locate the C64 A/V Port

The A/V port is an 8-pin DIN connector on the right side of the C64 (next to the power supply connector).

### Step 2: Connect the A/V Cable

1. Connect the 8-pin DIN end to the C64 A/V port
2. Identify the audio output on the RCA connectors (usually white or red)
3. **Note**: Some cables combine audio and video - use the audio-only connector

### Step 3: Connect to Audio Interface

**Option A: RCA to 1/4" (recommended for professional audio interfaces)**
```
C64 A/V → RCA cable → RCA to 1/4" adapter → Audio interface line input
```

**Option B: RCA to 3.5mm (for consumer audio interfaces)**
```
C64 A/V → RCA cable → RCA to 3.5mm adapter → Audio interface line/mic input
```

**Option C: Direct RCA (if your interface has RCA inputs)**
```
C64 A/V → RCA cable → Audio interface RCA input
```

### Step 4: Configure Audio Interface

1. **Input Type**: Set to LINE level (not MIC)
   - If only mic input available, reduce gain significantly
2. **Sample Rate**: 44.1kHz or 48kHz recommended
3. **Bit Depth**: 24-bit for best dynamic range
4. **Input Gain**: Start low, adjust for optimal level

---

## Gain Staging

### Setting Optimal Levels

**Objective**: Achieve strong signal without clipping or distortion

**Procedure**:
1. Load SID SUPERSTATION on the C64
2. Play a patch with maximum volume (all voices playing, filter resonance high)
3. Adjust audio interface input gain:
   - Peak levels should hit around -6dB to -3dB
   - Avoid going above -1dB (prevents clipping)
   - Avoid staying below -20dB (poor signal-to-noise ratio)

### Visual Guide to Levels

```
Metering Display (dB scale):

-60 -40 -20 -12 -6  -3  -1   0
 |   |   |   |   |   |   |   |
 └───┴───┴───┴───┴───┴───┴───┘
     TOO LOW        IDEAL   CLIP!
                    RANGE
```

**Ideal Range**: -12dB to -3dB for most signals

---

## DAW Configuration

### Recommended Settings

**Sample Rate**:
- 44.1kHz (CD quality) - Recommended
- 48kHz (Video standard) - Also good
- Higher rates (96kHz+) - Unnecessary for SID chip

**Buffer Size**:
- **Recording**: 512-1024 samples (lower latency for monitoring)
- **Mixing**: 1024-2048 samples (more CPU headroom)

**Input Monitoring**:
- Enable to hear C64 output while playing
- Use "Input Monitor" or "Direct Monitor" on audio interface
- Adjust latency compensation if needed

### Popular DAW Setup

**Ableton Live**:
1. Preferences → Audio → Input Config
2. Enable channel for audio interface input
3. Create audio track, set input to interface channel
4. Enable "Monitor: In" for live monitoring
5. Arm track for recording

**Logic Pro X**:
1. Create audio track
2. Set input to audio interface channel
3. Enable "Input Monitoring"
4. Adjust input gain in mixer
5. Arm track and record

**Reaper**:
1. Insert → New Track
2. Route → Input → Audio Input 1 (or appropriate channel)
3. Enable monitoring (red speaker icon)
4. Adjust input gain
5. Arm and record

**FL Studio**:
1. Mixer → Insert → In 1 (or corresponding input)
2. Enable recording on mixer track
3. Create audio clip in playlist
4. Adjust input level
5. Record

---

## Recording Tips

### Preparation

**Before Recording**:
1. **Test Signal**: Verify connection and levels
2. **Set Tempo**: Match C64 sequencer tempo to DAW tempo if syncing
3. **Arm Track**: Prepare recording track in DAW
4. **Disable Effects**: Record dry signal, add effects in post

### Recording Techniques

**Single-Take Recording**:
- Record complete performance from start to finish
- Good for live improvisations or full sequences
- Press RUN/STOP on C64 to start sequencer
- Hit record in DAW simultaneously

**Multi-Track Recording**:
1. Record Voice 1 alone (mute voices 2 & 3 in patch)
2. Record Voice 2 alone (mute voices 1 & 3)
3. Record Voice 3 alone (mute voices 1 & 2)
4. Mix and process individually in DAW

**Pattern-by-Pattern**:
- Record each pattern separately
- Allows for easier editing and arrangement
- Build full song in DAW from pattern recordings

### Recording Checklist

- [ ] Audio interface connected and powered
- [ ] C64 A/V cable properly connected
- [ ] DAW input configured to audio interface
- [ ] Input gain set correctly (peaking -6dB to -3dB)
- [ ] Monitoring enabled (if desired)
- [ ] Recording track armed
- [ ] C64 patch/sequence ready
- [ ] Hit RECORD!

---

## Noise Reduction

### Common Noise Sources

1. **Ground Loop Hum** (50/60Hz buzz)
2. **Power Supply Noise** (high-frequency whine)
3. **RF Interference** (crackling, buzzing)
4. **SID Chip Character** (some noise is inherent)

### Reducing Noise

**Hardware Solutions**:

1. **Ground Loop Isolator**:
   - Breaks ground loops between C64 and audio interface
   - Small device inserted in audio cable
   - Cost: ~$20-40

2. **Power Conditioning**:
   - Use clean, isolated power source for C64
   - Keep C64 power supply away from audio cables
   - Consider linear power supply upgrade

3. **Proper Cabling**:
   - Use shielded audio cables
   - Keep audio cables away from power cables
   - Shortest practical cable length

4. **C64 Modifications** (advanced):
   - Replace audio output capacitor
   - Add filtering to audio output
   - Install video/audio separation board
   - **Note**: Requires soldering skills

**Software Solutions**:

1. **Noise Gate** (DAW plugin):
   - Set threshold below signal, above noise floor
   - Silences output when no signal present

2. **EQ**:
   - High-pass filter at 30-40Hz (remove rumble)
   - Notch filter at 50/60Hz (remove hum)

3. **Noise Reduction Plugins**:
   - iZotope RX (professional)
   - Audacity Noise Reduction (free)
   - Capture noise profile during silence, apply to recording

---

## Alternative Output Methods

### Monitor Output

Some C64 setups route audio to RF modulator or composite video output. For best quality:
- **Always use the dedicated A/V port audio output**
- Avoid RF modulator (poor audio quality)
- Avoid using monitor's audio output (often noisy)

### Internal Modifications

**SID2SID** (dual SID chips):
- Outputs two SID chips in stereo
- Requires hardware modification
- SID SUPERSTATION can potentially be extended to support this

**Direct SID Output**:
- Some mods tap audio directly from SID chip
- Better isolation from C64 internal noise
- Requires electronics knowledge

---

## Stereo Expansion Techniques

The C64 SID chip outputs mono audio. To create stereo width:

### Recording Technique

1. **Double-Track**:
   - Record same part twice with slight variations
   - Pan one left, one right
   - Subtle detuning creates width

2. **Multi-Voice Spread**:
   - Record Voice 1 + Voice 2 panned left
   - Record Voice 3 panned right
   - Creates pseudo-stereo

### Post-Processing

1. **Stereo Imaging Plugins**:
   - Stereo widener
   - Mid-side processing
   - Haas effect (delay one channel slightly)

2. **Reverb**:
   - Wide stereo reverb
   - Different reverb on each voice
   - Creates space and width

---

## Connection Troubleshooting

### No Sound

**Checks**:
- [ ] A/V cable fully inserted
- [ ] Correct input selected on audio interface
- [ ] Audio interface monitoring enabled
- [ ] C64 master volume not at zero (press F1, check volume)
- [ ] DAW input gain not at zero
- [ ] Cables not damaged

### Distorted Sound

**Causes**:
- Input gain too high (reduce interface gain)
- Mic input instead of line input (switch to line)
- Damaged cable (replace cable)
- Overdriven SID chip (reduce master volume)

### Hum or Buzz

**Solutions**:
- Check for ground loops (use isolator)
- Move C64 power supply away from audio cables
- Use balanced cables if possible
- Check cable shielding

### One Channel Only

**Checks**:
- C64 outputs mono (pan to center in DAW)
- If stereo track, duplicate mono signal to both channels
- Adapter may be stereo-configured (use mono adapter)

---

## Professional Recording Setup

### Recommended Chain

```
┌──────────┐    ┌────────────┐    ┌──────────────┐    ┌─────────┐
│    C64   │    │   Ground   │    │Professional  │    │   DAW   │
│  A/V Out │────│    Loop    │────│    Audio     │────│Computer │
│          │    │  Isolator  │    │  Interface   │    │         │
└──────────┘    └────────────┘    └──────────────┘    └─────────┘
                                          │
                                          ▼
                                   ┌──────────────┐
                                   │   Powered    │
                                   │   Monitors   │
                                   └──────────────┘
```

### Signal Path Quality Hierarchy

**Best to Worst**:
1. ⭐⭐⭐⭐⭐ C64 A/V port → High-quality interface → DAW
2. ⭐⭐⭐⭐ C64 A/V port → Ground loop isolator → Interface → DAW
3. ⭐⭐⭐ C64 A/V port → Consumer interface → DAW
4. ⭐⭐ C64 RF modulator → Tuner → Recorder (avoid if possible)
5. ⭐ Monitor headphone out → Interface (worst, very noisy)

---

## Live Performance Setup

### Connecting to PA System

```
C64 → DI Box → PA Mixer → PA System
```

**DI Box Benefits**:
- Converts unbalanced to balanced signal
- Allows long cable runs without noise
- Ground lift switch helps eliminate hum
- Phantom power from mixer

### Recommended DI Boxes

- **Radial ProDI** (passive, excellent quality)
- **Behringer Ultra-DI DI100** (budget option)
- **Countryman Type 85** (active, high-end)

---

## Maintenance

### Cable Care

- Coil cables loosely (avoid kinks)
- Store in dry location
- Clean connectors periodically with contact cleaner
- Replace worn cables promptly

### C64 Maintenance

- Keep dust out of computer
- Check solder joints on A/V port if connection intermittent
- Test audio output periodically with different cables

---

## Conclusion

With proper connection and gain staging, SID SUPERSTATION can deliver excellent audio quality for recording and live performance. Experiment with different connection methods and noise reduction techniques to find what works best for your setup.

**Happy recording! 🎵**

---

## Additional Resources

- [C64 Hardware Modifications](https://www.c64-wiki.com/wiki/Modifications)
- [Audio Interface Buyer's Guide](https://www.soundonsound.com)
- [Recording SID Music Discussion](https://csdb.dk)
