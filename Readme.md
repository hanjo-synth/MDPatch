# **Machinedrum Randomizer**

**Machinedrum Randomizer** is a MIDI CC randomizer tool for **Elektron Machinedrum** (or any CC-capable synth), designed for fast sound exploration and live performance.  
Send randomized MIDI CC values to multiple parameters across pages and subpages for unpredictable sonic results.

**Author:** HANJO – Tokyo, Japan

![Machinedrum Randomizer Screenshot](./screenshot.png)

---

## **FEATURES**

- **`K3`**: Randomize all 8 parameter values in the current subpage
- **`E1`**: Change main page (`SYNTH`, `FILTER`, `EFFECTS`)
- **`E2`**: Select parameter slot (1–8) or scroll subpages (`A–D`) when holding `K2`
- **`K2`**: Toggle edit mode:
  - `CC`: Change CC target
  - `VAL`: Change value
  - `MIDI`: Change MIDI channel
- **`E3`**: Adjust parameter (CC number, value, or MIDI channel depending on mode)

---

## **CC MAPPING**

Each page contains 4 subpages (`A–D`), and each subpage controls 8 fixed CC numbers.  
The Machinedrum assigns tracks based on **MIDI channel**, starting from the **Base Channel**.

### Track Assignment by MIDI Channel

- **Base Channel**  
  - A → BD (Bass Drum)  
  - B → SD (Snare Drum)  
  - C → HT (High Tom)  
  - D → MT (Mid Tom)

- **Base Channel + 1**  
  - A → LT (Low Tom)  
  - B → CP (Clap)  
  - C → RS (Rim Shot)  
  - D → CB (Cowbell)

- **Base Channel + 2**  
  - A → CH (Closed Hi-hat)  
  - B → OH (Open Hi-hat)  
  - C → RC (Ride Cymbal)  
  - D → CC (Crash Cymbal)

- **Base Channel + 3**  
  - A → M1  
  - B → M2  
  - C → M3  
  - D → M4  
  *(Used for RAM Machines or CTR Machines depending on Machinedrum config)*

### Subpage CC Numbers

| Page     | Subpage | CC Numbers       |
|----------|---------|------------------|
| SYNTH    | A       | 16–23            |
|          | B       | 40–47            |
|          | C       | 72–79            |
|          | D       | 96–103           |
| FILTER   | A       | 24–31            |
|          | B       | 48–55            |
|          | C       | 80–87            |
|          | D       | 104–111          |
| EFFECTS  | A       | 32–39            |
|          | B       | 56–63            |
|          | C       | 88–95            |
|          | D       | 112–119          |


---

## **OUTPUTS**

- Sends randomized or manually set **MIDI CC messages** over USB
- Default **MIDI Channel**: `9` (adjustable per subpage)

---

## **UPDATES**

**v1.0** Initial release  
More features to come (parameter locks, save/recall, performance macros)

---

## **TECHNICAL DETAILS**

- Organizes 96 CC values across 3 pages and 12 subpages
- Remembers values per subpage
- Flexible edit system: toggle between CC number, value, and MIDI channel
- Designed for fast tweaking or total chaos during live sets

---

## **REQUIREMENTS**

- **Monome Norns** (any model)
- **Elektron Machinedrum** or other MIDI CC-capable gear
- USB MIDI interface (for DIN MIDI out if needed)

---

## **INSTALLATION**

1. Clone or download this repository into your `dust/code/` folder on Norns
2. Run the script from the `SELECT` screen

---

## **USAGE TIPS**

- Hold **`K2`** and turn **`E2`** to quickly flip between subpages (A–D)
- Use **`K3`** often for sonic surprises
- Use subpages to organize parameter groups (e.g., pitch, timbre, modulation)
- Set MIDI channels per subpage to control multiple tracks

---

## **CREDITS**

Created by **HANJO**  

---
