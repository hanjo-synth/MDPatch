# **Machinedrum Randomizer**

**Machinedrum Randomizer** is a powerful and flexible MIDI CC randomizer for the **Elektron Machinedrum** (or any CC-capable synth).  
Built for fast sonic experimentation and live performance, it allows direct access to every track and MIDI CC group through a responsive UI.

**Authors:** HANJO – Tokyo, Japan & Synthetic Juddah – Ural Mountains, Russia

![Machinedrum Randomizer Screenshot](./screenshot.png)

---

## **FEATURES**

- **`K1`**: Select Machinedrum track (BD, SD, etc.)
- **`K2 + E2`**: Change main page (`SYNTH`, `EFFECTS`, `ROUTING`)
- **`K3`**: Randomize all 8 parameters in the current subpage
- **`K2 + K3`**: Open Settings menu
- **`E1`**: Scroll between parameter slots
- **`K2`**: Toggle edit mode (`CC`, `VAL`, `MIDI`)
- **`E2`**: Select page or menu item (depending on context)
- **`E3`**: Adjust value of current item (parameter value, CC number, or MIDI channel)

---

## **TRACK & CHANNEL MAPPING**

Each Machinedrum voice is assigned by track and MIDI channel.

### Track Assignments (Based on Base MIDI Channel)

| Track     | MIDI Channel Offset | Subpage |
|-----------|---------------------|---------|
| 1–4       | Base + 0            | A–D     |
| 5–8       | Base + 1            | A–D     |
| 9–12      | Base + 2            | A–D     |
| 13–16     | Base + 3            | A–D     |

Examples:

- BD = Track 1 → Subpage A on Base Channel  
- SD = Track 2 → Subpage B on Base Channel  
- CH = Track 9 → Subpage A on Base Channel + 2  
- M4 = Track 16 → Subpage D on Base Channel + 3  

---

## **CC MAPPING**

Organized into 3 pages (`SYNTH`, `EFFECTS`, `ROUTING`), each with 4 subpages (`A–D`) and 8 CC targets per subpage.

| Page     | Subpage | CC Numbers       |
|----------|---------|------------------|
| SYNTH    | A       | 16–23            |
|          | B       | 40–47            |
|          | C       | 72–79 *(one dup)*|
|          | D       | 96–103           |
| EFFECTS  | A       | 24–31            |
|          | B       | 48–55            |
|          | C       | 80–87            |
|          | D       | 104–111          |
| ROUTING  | A       | 32–39            |
|          | B       | 56–63            |
|          | C       | 88–95            |
|          | D       | 112–119          |

*Note: Some CC ranges overlap or repeat intentionally to reflect Machinedrum's flexible architecture.*

---

## **OUTPUT**

- Sends **MIDI CC messages** over USB
- Each subpage corresponds to a specific track and MIDI channel
- Randomized or manually adjusted values are instantly transmitted

---

## **SETTINGS MENU**

Accessed via **`K2 + K3`**, the menu lets you fine-tune global behavior:

- **MD Base Ch.** – Sets the starting channel (1–16)
- **CC Val. Min.** – Minimum value for randomization (1–127)
- **CC Val. Max.** – Maximum value for randomization (1–127)

---

## **VERSION**

**v1.4** – Latest release  
- New routing page  
- Full track select system  
- Menu system overhaul  
- Enhanced CC control and min/max value range  
- Improved UI performance

---

## **REQUIREMENTS**

- **Monome Norns** (any model)
- **Elektron Machinedrum** (or other MIDI CC device)
- USB MIDI (DIN adapter if needed)

---

## **INSTALLATION**

1. Clone or download this repository into your `dust/code/` folder on your Norns
2. Launch the script via the SELECT screen

---

## **TIPS & TRICKS**

- Quickly flip between instruments with **`K1`**
- Randomize sounds instantly with **`K3`**
- Use pages to organize control sets (e.g., pitch, FX, routing)
- Fine-tune randomness using the **menu**
- Multiple Machinedrum tracks can be controlled by setting different MIDI channels per subpage

---
