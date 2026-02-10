# Keyboard Mapping Reference

## Overview

SID SUPERSTATION uses the C64 keyboard for both musical input (piano mode) and parameter control. This guide documents all keyboard functions.

---

## Function Keys

| Key | Primary Function | Secondary Function (SHIFT) |
|-----|------------------|---------------------------|
| **F1** | Oscillator Page | - |
| **F2** | Envelope Page | - |
| **F3** | Filter Page | - |
| **F4** | Arpeggiator Page | - |
| **F5** | LFO Page | - |
| **F6** | Save Page | - |
| **F7** | Sequencer Page | - |
| **F8** | Load Page | - |

**Usage**: Press function keys to switch between different editing pages in the UI.

---

## Piano Keyboard Layout

### Two-Row Piano Keyboard

The C64 keyboard is mapped to provide 2 octaves of chromatic notes:

```
┌───────────────────────────────────────────────┐
│  Black Keys (Sharps/Flats)                    │
│  ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐  │
│  │ 2 │ 3 │   │ 5 │ 6 │ 7 │   │ 9 │ 0 │   │  │
│  │C# │D# │   │F# │G# │A# │   │C# │D# │   │  │
│  └─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┘  │
│    │   │   │   │   │   │   │   │   │   │    │
│  White Keys (Natural Notes)                   │
│  ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐  │
│  │ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │  │
│  │ C │ D │ E │ F │ G │ A │ B │ C │ D │ E │  │
│  └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘  │
└───────────────────────────────────────────────┘
```

### Piano Key Mapping

#### White Keys (Natural Notes)

| Key | Note | MIDI Note (Octave 4) |
|-----|------|---------------------|
| **Q** | C | 60 (C4) |
| **W** | D | 62 (D4) |
| **E** | E | 64 (E4) |
| **R** | F | 65 (F4) |
| **T** | G | 67 (G4) |
| **Y** | A | 69 (A4) |
| **U** | B | 71 (B4) |
| **I** | C | 72 (C5) |
| **O** | D | 74 (D5) |
| **P** | E | 76 (E5) |

#### Black Keys (Sharps/Flats)

| Key | Note | MIDI Note (Octave 4) |
|-----|------|---------------------|
| **2** | C# / Db | 61 |
| **3** | D# / Eb | 63 |
| **5** | F# / Gb | 66 |
| **6** | G# / Ab | 68 |
| **7** | A# / Bb | 70 |
| **9** | C# / Db | 73 |
| **0** | D# / Eb | 75 |

---

## Octave Control

| Key | Function | Range |
|-----|----------|-------|
| **Z** | Octave Down | C-1 to C7 |
| **X** | Octave Up | C-1 to C7 |

**Default Octave**: 4 (Middle C = C4)

**Usage**: 
- Press **Z** to shift keyboard down one octave
- Press **X** to shift keyboard up one octave
- Current octave affects all piano keys
- Useful for playing bass lines or high melodies

---

## Navigation Keys

### Cursor Movement

| Key | Function | Description |
|-----|----------|-------------|
| **↑** | Up | Move cursor up / Navigate parameters |
| **↓** | Down | Move cursor down / Navigate parameters |
| **←** | Left | Move cursor left / Previous item |
| **→** | Right | Move cursor right / Next item |

### Parameter Editing

| Key | Function | Description |
|-----|----------|-------------|
| **+** | Increment | Increase selected parameter value |
| **-** | Decrement | Decrease selected parameter value |
| **RETURN** | Confirm | Confirm selection / Enter edit mode |
| **DEL** | Delete | Clear selected item / Delete value |

---

## Sequencer Controls

### Transport Controls

| Key | Function | Description |
|-----|----------|-------------|
| **RUN/STOP** | Play/Stop | Toggle sequencer playback |
| **SHIFT + RUN/STOP** | Pause | Pause playback (keep position) |
| **CTRL + R** | Record | Enable recording mode |
| **CTRL + RETURN** | Pattern Play | Play current pattern only |

### Step Entry (Sequencer Mode)

| Key | Function | Description |
|-----|----------|-------------|
| **SPACE** | Rest | Insert rest (no note) |
| **=** | Tie | Tie to previous note |
| **A** | Accent | Toggle accent on step |
| **S** | Slide | Toggle slide/portamento |
| **G** | Gate | Toggle gate on/off |

### Pattern Management

| Key | Function | Description |
|-----|----------|-------------|
| **C** | Copy | Copy current pattern |
| **V** | Paste | Paste copied pattern |
| **SHIFT + C** | Clear | Clear current pattern |
| **N** | New | Create new pattern |

---

## Parameter Shortcuts

### Voice Selection

| Key | Function | Description |
|-----|----------|-------------|
| **1** | Voice 1 | Select voice 1 for editing |
| **2** | Voice 2 | Select voice 2 for editing |
| **3** | Voice 3 | Select voice 3 for editing |

### Waveform Selection (with voice selected)

| Key | Function | Waveform |
|-----|----------|----------|
| **T** | Triangle | Select triangle waveform |
| **S** | Sawtooth | Select sawtooth waveform |
| **P** | Pulse | Select pulse waveform |
| **N** | Noise | Select noise waveform |

### Quick Parameter Access

| Key | Function | Description |
|-----|----------|-------------|
| **F** | Filter | Quick access to filter settings |
| **L** | LFO | Quick access to LFO settings |
| **A** | Arpeggiator | Quick access to arp settings |

---

## File Management Keys

### Save/Load Operations (F6/F8 Pages)

| Key | Function | Description |
|-----|----------|-------------|
| **RETURN** | Confirm | Execute save/load |
| **DEL** | Delete | Delete file (with confirmation) |
| **SHIFT + D** | Directory | Refresh directory listing |
| **SHIFT + F** | Format | Format disk (with confirmation) |

### Filename Entry

| Key | Function | Description |
|-----|----------|-------------|
| **A-Z** | Characters | Enter alphanumeric characters |
| **0-9** | Numbers | Enter numbers |
| **SPACE** | Space | Insert space in filename |
| **DEL** | Backspace | Delete previous character |
| **RETURN** | Done | Finish filename entry |

---

## Special Key Combinations

### SHIFT Modifiers

| Combination | Function | Description |
|-------------|----------|-------------|
| **SHIFT + 1-8** | Quick Patch | Load quick patch 1-8 |
| **SHIFT + P** | Panic | All notes off / Reset |
| **SHIFT + I** | Initialize | Reset to default patch |
| **SHIFT + T** | Tap Tempo | Tap to set tempo |

### CTRL Modifiers

| Combination | Function | Description |
|-------------|----------|-------------|
| **CTRL + S** | Save | Quick save current patch |
| **CTRL + L** | Load | Quick load dialog |
| **CTRL + N** | New | Clear current patch |
| **CTRL + C** | Copy | Copy current settings |

### Commodore Key (C=) Modifiers

| Combination | Function | Description |
|-------------|----------|-------------|
| **C= + R** | Reset | Soft reset (keep patches) |
| **C= + H** | Help | Show help screen |
| **C= + M** | MIDI | MIDI settings (if available) |

---

## Joystick Controls (Port 2)

### Joystick Functions

| Direction | Function | Description |
|-----------|----------|-------------|
| **Up** | Parameter +1 | Increment selected parameter |
| **Down** | Parameter -1 | Decrement selected parameter |
| **Left** | Previous | Previous parameter/item |
| **Right** | Next | Next parameter/item |
| **Fire** | Select | Select/confirm |

**Note**: Joystick provides alternative parameter control without disrupting piano keyboard mode.

---

## Context-Sensitive Keys

Some keys change function based on current page/mode:

### Synth Page (F1)
- **T/S/P/N**: Select waveform
- **1/2/3**: Select voice
- **O**: Octave shift mode

### Sequencer Page (F7)
- **SPACE**: Insert rest
- **1-16**: Jump to step
- **A**: Accent
- **G**: Gate toggle

### Filter Page (F3)
- **L**: Low-pass
- **B**: Band-pass
- **H**: High-pass
- **R**: Resonance adjust mode

### LFO Page (F5)
- **1-4**: Select LFO
- **T/S/Q/R**: LFO waveform (Triangle/Saw/sQuare/Random)
- **D**: Destination select

---

## Quick Reference Card

### Essential Shortcuts

```
┌─────────────────────────────────────────┐
│ ESSENTIAL KEYBOARD SHORTCUTS            │
├─────────────────────────────────────────┤
│ F1-F8        Navigate pages             │
│ Q-P, 2-0     Piano keyboard             │
│ Z/X          Octave down/up             │
│ RUN/STOP     Play/Stop sequencer        │
│ +/-          Adjust parameter           │
│ Cursors      Navigate UI                │
│ SHIFT+P      Panic (all notes off)      │
│ CTRL+S       Quick save                 │
└─────────────────────────────────────────┘
```

---

## Tips for Efficient Workflow

1. **Learn Function Keys**: Memorize F1-F8 for quick page switching
2. **Use Octave Shifts**: Keep Z/X handy for quick octave changes
3. **Joystick for Tweaking**: Use joystick while playing keyboard with other hand
4. **Quick Patches**: Use SHIFT+1-8 for instant preset recall
5. **CTRL+S Often**: Save frequently to avoid losing work

---

## Keyboard Layout Diagram

```
┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬─────────┐
│ ←  │ 1  │ 2  │ 3  │ 4  │ 5  │ 6  │ 7  │ 8  │ 9  │ 0  │ +  │ -  │ £       │
│    │V1  │ C# │ D# │    │ F# │ G# │ A# │    │ C# │ D# │ ++ │ -- │         │
├────┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬─┴──┬──────┤
│ CTRL  │ Q  │ W  │ E  │ R  │ T  │ Y  │ U  │ I  │ O  │ P  │ @  │ *  │      │
│       │ C  │ D  │ E  │ F  │ G  │ A  │ B  │ C  │ D  │ E  │    │    │      │
├───────┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┐     │
│ RUN/   │ A  │ S  │ D  │ F  │ G  │ H  │ J  │ K  │ L  │ :  │ ;  │ =  │     │
│ STOP   │Acc │Sld │    │Flt │Gat │    │    │    │LFO │    │    │Tie │     │
├────┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴┬───┴────┴─────┤
│ C= │SHFT│ Z  │ X  │ C  │ V  │ B  │ N  │ M  │ ,  │ .  │ /  │ SHIFT        │
│    │    │Oct-│Oct+│Copy│Pst │    │New │    │    │    │    │              │
├────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴──────────────┤
│                         SPACE                                             │
└───────────────────────────────────────────────────────────────────────────┘
```

---

**For more information, see:**
- [User Manual](USER_MANUAL.md)
- [SID Registers Reference](SID_REGISTERS.md)
