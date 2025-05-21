-- Machinedrum Randomizer v1.3
-- HANJO, Tokyo, Japan

local midi_out
local channel = 1

local num_slots_per_page = 8
local num_pages = 3
local current_page = 1
local current_subpage = 1
local max_subpages = {4, 4, 4} -- Each page now has 4 subpages (A-D)

local page_data = {
  {
    title = "SYNTH",
    subpages = {
      {name = "A", cc_targets = {16, 17, 18, 19, 20, 21, 22, 23}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "B", cc_targets = {40, 41, 42, 43, 44, 45, 46, 47}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "C", cc_targets = {72, 73, 74, 75, 76, 45, 77, 78}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "D", cc_targets = {96, 97, 98, 99, 100, 101, 102, 103}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
    }
  },
  {
    title = "FILTER",
    subpages = {
      {name = "A", cc_targets = {24, 25, 26, 27, 28, 29, 30, 31}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "B", cc_targets = {48, 49, 50, 51, 52, 53, 54, 55}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "C", cc_targets = {80, 81, 82, 83, 84, 85, 86, 87}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "D", cc_targets = {104, 105, 106, 107, 108, 109, 110, 111}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
    }
  },
  {
    title = "EFFECTS",
    subpages = {
      {name = "A", cc_targets = {32, 33, 34, 35, 36, 37, 38, 39}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "B", cc_targets = {56, 57, 58, 59, 60, 61, 62, 63}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "C", cc_targets = {88, 89, 90, 91, 92, 93, 94, 95}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "D", cc_targets = {112, 113, 114, 115, 116, 117, 118, 119}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
    }
  }
}

local selected_slot = 1
local edit_mode = "cc"
local k2_held = false

function init()
  midi_out = midi.connect(1)

  params:add_separator("CC Randomizer Settings")
  params:add_number("midi_channel", "MIDI Channel", 1, 16, 1)
  params:set_action("midi_channel", function(val) channel = val end)
  params:add_number("cc_val_min", "Value Min", 0, 127, 0)
  params:add_number("cc_val_max", "Value Max", 0, 127, 127)

  clock.run(redraw_loop)
end

function get_current_page_data()
  return page_data[current_page].subpages[current_subpage]
end

function send_dice_roll()
  local current_data = get_current_page_data()
  local val_min = params:get("cc_val_min")
  local val_max = params:get("cc_val_max")
  local ch = params:get("midi_channel")

  for i = 1, num_slots_per_page do
    local cc = current_data.cc_targets[i]
    if cc >= 0 then
      local val = math.random(val_min, val_max)
      current_data.cc_values[i] = val
      midi_out:cc(cc, val, ch)
      print("🎲 Page " .. current_page .. " Sub " .. current_subpage .. " Slot " .. i .. " → CC " .. cc .. " = " .. val)
    end
  end
end

function key(n, z)
  if n == 2 then
    k2_held = (z == 1)
    if z == 1 then
      if edit_mode == "cc" then
        edit_mode = "value"
      elseif edit_mode == "value" then
        edit_mode = "midi"
      else
        edit_mode = "cc"
      end
    end
  elseif n == 3 and z == 1 then
    send_dice_roll()
  end
end

function enc(n, d)
  if n == 1 then
    current_page = util.clamp(current_page + d, 1, num_pages)
    current_subpage = 1
    selected_slot = 1
  elseif n == 2 then
    if k2_held then
      local max_sub = max_subpages[current_page] or 1
      current_subpage = util.clamp(current_subpage + d, 1, max_sub)
    else
      selected_slot = util.clamp(selected_slot + d, 1, num_slots_per_page)
    end
  elseif n == 3 then
    local current_data = get_current_page_data()
    if edit_mode == "cc" then
      local new_cc = util.clamp(current_data.cc_targets[selected_slot] + d, -1, 127)
      current_data.cc_targets[selected_slot] = new_cc
    elseif edit_mode == "value" then
      local new_val = util.clamp(current_data.cc_values[selected_slot] + d, 0, 127)
      current_data.cc_values[selected_slot] = new_val
      local cc = current_data.cc_targets[selected_slot]
      if cc >= 0 then
        midi_out:cc(cc, new_val, params:get("midi_channel"))
      end
    elseif edit_mode == "midi" then
      local new_channel = util.clamp(params:get("midi_channel") + d, 1, 16)
      params:set("midi_channel", new_channel)
    end
  end
end

function redraw()
  screen.clear()
  screen.font_size(8)

  local current_data = get_current_page_data()
  local page = page_data[current_page]
  local sub = page.subpages[current_subpage]

  local title = page.title .. " " .. sub.name
  local title_x = (128 - (#title * 8)) / 2 + 6
  screen.move(title_x, 5)
  screen.text(title)

  for i = 1, 4 do
    draw_slot(i, current_data, 2, 15 + (i - 1) * 10)
  end
  for i = 5, 8 do
    draw_slot(i, current_data, 68, 15 + (i - 5) * 10)
  end

  screen.move(4, 60)
  screen.text("K3: Roll")
  screen.move(54, 60)
  screen.text(string.format("E1:%02d %s", current_page, sub.name))
  screen.move(96, 60)
  if edit_mode == "cc" then
    screen.text("CC")
  elseif edit_mode == "value" then
    screen.text("VAL")
  elseif edit_mode == "midi" then
    screen.text(string.format("MIDI %02d", params:get("midi_channel")))
  end

  screen.update()
end

function draw_slot(i, data, x, y)
  local marker = (selected_slot == i) and ">" or " "
  local cc = data.cc_targets[i]
  local cc_str = (cc == -1) and "OFF " or string.format("CC%3d", cc)
  screen.move(x, y)
  screen.text(string.format("%s%d: %s→%3d", marker, i, cc_str, data.cc_values[i]))
end

function redraw_loop()
  while true do
    redraw()
    clock.sleep(1 / 15)
  end
end
