# Patch Directory

This directory contains binary patch files for the SID SUPERSTATION synthesizer.

## File Formats

- `.pat` - Single patch file (68 bytes: 4-byte header + 64-byte patch data)
- `.bnk` - Patch bank file (all 128 patches)

## Patch Structure

Each patch contains 64 bytes of data:

- **Bytes 0-7**: Patch name (PETSCII)
- **Bytes 8-14**: Voice 1 parameters (waveform, ADSR, pulse width, octave, detune)
- **Bytes 15-21**: Voice 2 parameters
- **Bytes 22-28**: Voice 3 parameters
- **Bytes 29-32**: Filter parameters
- **Bytes 33-48**: LFO parameters (4 LFOs × 4 bytes each)
- **Bytes 49-51**: Arpeggiator parameters
- **Bytes 52-63**: Reserved for future use

## Creating Patches

Patches can be created in two ways:

1. **Using the synth**: Edit parameters and save using F6 (SAVE)
2. **Manually**: Create binary files following the structure above

## Default Patches

The synthesizer includes built-in default patches that are loaded on startup.

