# Machinedrum Randomizer

A companion tool for Elektron Machinedrum users — built for Monome Norns — to randomize CC values across the machine’s powerful MIDI parameters.

Developed with live experimentation in mind, this script allows fast access to synth, filter, and effects parameter changes using pre-mapped CC sets. It’s designed to spark unexpected textures and variations, ideal for performance or exploratory patch creation.

---

## ✨ Features

- 🎛 Page-based CC organization:
  - **SYNTH**, **FILTER**, **EFFECTS**
- 🧱 Each page has up to **4 subpages** (A–D), each with its own set of 8 CCs
- 🎲 Instant CC randomization with `K3`
- 🎚 Edit mode toggling with `K2`:
  - `CC`: adjust CC number
  - `VAL`: adjust current value
  - `MIDI`: change output MIDI channel
- 🔁 Subpage switching by holding `K2` and turning `E2`
- 💾 Independent value storage per subpage
- 🧩 Easily expandable structure

---

## 📟 Controls

### Encoders

- `E1`: Change Page (SYNTH, FILTER, EFFECTS)
- `E2`: Move between slots (or subpages when holding `K2`)
- `E3`: Adjust parameter (CC number, value, or MIDI channel depending on mode)

### Keys

- `K2`: Hold to enter subpage scroll mode (with `E2`). Press to cycle `edit_mode`:
  - `CC` → `VAL` → `MIDI`
- `K3`: Roll random values across the 8 active parameters in current subpage

---

## 🎛 CC Mapping

Each page is divided into subpages with fixed CC sets.

### SYNTH Page

| Subpage | CC Numbers                    |
|---------|-------------------------------|
| A       | 16–23                         |
| B       | 40–47                         |
| C       | 72–78                         |
| D       | 96–103                        |

### FILTER Page

| Subpage | CC Numbers                    |
|---------|-------------------------------|
| A       | 24–31                         |
| B       | 48–55                         |
| C       | 80–87                         |
| D       | 104–111                       |

### EFFECTS Page

| Subpage | CC Numbers                    |
|---------|-------------------------------|
| A       | 32–39                         |
| B       | 56–63                         |
| C       | 88–95                         |
| D       | 112–119                       |

---

## 🎚 Requirements

- [Monome Norns](https://monome.org/norns/)
- Elektron Machinedrum with MIDI input connected
- MIDI interface (USB MIDI to DIN or similar)

---

## 🛠 Installation

1. Download or clone this repo
2. Place the folder into `dust/code/machinedrum_randomizer/`
3. Launch from the `MAIDEN` or Norns menu

---

## 📡 MIDI Setup

- Connect your MIDI interface to Machinedrum
- Use `PARAMS > MIDI Channel` to select output channel
- Ensure your Machinedrum is set to receive external CC on that channel

---

## 🧪 Known Quirks / Ideas

- No per-patch save yet — values reset on reboot
- Could be extended with performance macros, per-track focus, or parameter locks
- Randomization range adjustable via parameters

---

## 🧑‍💻 Credits

Developed by [David](https://github.com/hanjo-synth), Tokyo  
Forked and extended from `Mnmpatch` (Monomachine)

Contributions, pull requests, and forks welcome!

---
