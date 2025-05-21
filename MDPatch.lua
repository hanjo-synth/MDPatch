-- Machinedrum Randomizer v1.4
-- HANJO, Tokyo, Japan
-- Synthetic Juddah, Ural Mountains, Russia
-- 
-- K1 == Track select
-- K2 + K3 == Settings
-- K2 + E2 == Page select
-- K1 == Track select

local midi_out
local channel = 1

-- Track selection system
local instruments = {
  {name = "1-BD", channel_offset = 0, subpage = 1},
  {name = "2-SD", channel_offset = 0, subpage = 2},
  {name = "3-HT", channel_offset = 0, subpage = 3},
  {name = "4-MT", channel_offset = 0, subpage = 4},
  {name = "5-LT", channel_offset = 1, subpage = 1},
  {name = "6-CP", channel_offset = 1, subpage = 2},
  {name = "7-RS", channel_offset = 1, subpage = 3},
  {name = "8-CB", channel_offset = 1, subpage = 4},
  {name = "9-CH", channel_offset = 2, subpage = 1},
  {name = "10-OH", channel_offset = 2, subpage = 2},
  {name = "11-RC", channel_offset = 2, subpage = 3},
  {name = "12-CC", channel_offset = 2, subpage = 4},
  {name = "13-M1", channel_offset = 3, subpage = 1},
  {name = "14-M2", channel_offset = 3, subpage = 2},
  {name = "15-M3", channel_offset = 3, subpage = 3},
  {name = "16-M4", channel_offset = 3, subpage = 4}
}
local selected_instrument = 1
local current_channel = 1

-- Menu system
local in_menu = false
local menu_opened_by_k2k3 = false
local menu_offset = 0
local menu_items = {
  {name = "MD Base Ch.", param = "midi_channel", min = 1, max = 16},
  {name = "CC Val. Min.:", param = "cc_val_min", min = 1, max = 127},
  {name = "CC Val. Max.:", param = "cc_val_max", min = 1, max = 127}
}
local menu_selected = 1

-- Original program data
local num_slots_per_page = 8
local num_pages = 3
local current_page = 1
local selected_slot = 1
local edit_mode = "cc"
local k2_held = false
local k3_held = false

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
    title = "EFFECTS",
    subpages = {
      {name = "A", cc_targets = {24, 25, 26, 27, 28, 29, 30, 31}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "B", cc_targets = {48, 49, 50, 51, 52, 53, 54, 55}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "C", cc_targets = {80, 81, 82, 83, 84, 85, 86, 87}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "D", cc_targets = {104, 105, 106, 107, 108, 109, 110, 111}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
    }
  },
  {
    title = "ROUTING",
    subpages = {
      {name = "A", cc_targets = {32, 33, 34, 35, 36, 37, 38, 39}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "B", cc_targets = {56, 57, 58, 59, 60, 61, 62, 63}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "C", cc_targets = {88, 89, 90, 91, 92, 93, 94, 95}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
      {name = "D", cc_targets = {112, 113, 114, 115, 116, 117, 118, 119}, cc_values = {0, 0, 0, 0, 0, 0, 0, 0}},
    }
  }
}

function init()
  midi_out = midi.connect(1)

  params:add_separator("CC Randomizer Settings")
  params:add_number("midi_channel", "MIDI Channel", 1, 16, 1)
  params:set_action("midi_channel", function(val) 
    channel = val
    update_current_channel()
  end)
  params:add_number("cc_val_min", "Value Min", 0, 127, 0)
  params:add_number("cc_val_max", "Value Max", 0, 127, 127)

  update_current_channel()
  clock.run(redraw_loop)
end

function update_current_channel()
  current_channel = channel + instruments[selected_instrument].channel_offset
end

function get_current_page_data()
  local subpage = instruments[selected_instrument].subpage
  return page_data[current_page].subpages[subpage]
end

function send_dice_roll()
  if in_menu then return end
  
  local current_data = get_current_page_data()
  local val_min = params:get("cc_val_min")
  local val_max = params:get("cc_val_max")

  for i = 1, num_slots_per_page do
    local cc = current_data.cc_targets[i]
    if cc >= 0 then
      local val = math.random(val_min, val_max)
      current_data.cc_values[i] = val
      midi_out:cc(cc, val, current_channel)
      print("🎲 "..instruments[selected_instrument].name.." Page "..current_page.." Slot "..i.." → CC "..cc.." = "..val)
    end
  end
end

function key(n, z)
  if n == 2 then
    k2_held = (z == 1)
    
    if z == 1 and k3_held and not in_menu then
      -- Open menu with K2+K3
      in_menu = true
      menu_opened_by_k2k3 = true
      menu_selected = 1
      menu_offset = 0
    elseif z == 1 and in_menu and menu_opened_by_k2k3 then
      -- Close menu with K2
      in_menu = false
      menu_opened_by_k2k3 = false
    elseif z == 0 and not in_menu and not menu_opened_by_k2k3 then
      -- Normal K2 behavior (only when not in menu)
      if edit_mode == "cc" then
        edit_mode = "value"
      -- elseif edit_mode == "value" then
      --   edit_mode = "midi"
      else
        edit_mode = "cc"
      end
    end
  elseif n == 3 then
    k3_held = (z == 1)
    
    if z == 1 and k2_held and not in_menu then
      -- Open menu with K2+K3
      in_menu = true
      menu_opened_by_k2k3 = true
      menu_selected = 1
      menu_offset = 0
    elseif z == 1 and not in_menu then
      send_dice_roll()
    end
  end
end

function enc(n, d)
  if in_menu then
    if n == 2 then
      -- Scroll through menu items
      menu_selected = util.clamp(menu_selected + d, 1, #menu_items)
      -- Adjust offset for display
      if menu_selected > menu_offset + 7 then
        menu_offset = menu_selected - 7
      elseif menu_selected < menu_offset + 1 then
        menu_offset = menu_selected - 1
      end
    elseif n == 3 then
      -- Edit selected parameter
      local item = menu_items[menu_selected]
      local current_val = params:get(item.param)
      local new_val = util.clamp(current_val + d, item.min, item.max)
      params:set(item.param, new_val)
    end
  else
    -- Original encoder behavior
    if n == 1 then
      selected_instrument = util.clamp(selected_instrument + d, 1, #instruments)
      update_current_channel()
    elseif n == 2 then
      if k2_held then
        current_page = util.clamp(current_page + d, 1, num_pages)
        selected_slot = 1
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
          midi_out:cc(cc, new_val, current_channel)
        end
      end
    end
  end
end

function draw_menu()
  screen.clear()
  screen.font_size(8)
  
  -- Menu title
  screen.move(64, 8)
  screen.text_center("SETTINGS")
  
  -- Draw visible menu items
  for i = 1, math.min(7, #menu_items - menu_offset) do
    local item_idx = i + menu_offset
    local item = menu_items[item_idx]
    local y_pos = 15 + (i-1)*8
    
    -- Highlight selected item
    if item_idx == menu_selected then
      screen.level(15)
      screen.move(4, y_pos)
      screen.text(">")
    else
      screen.level(5)
    end
    
    -- Draw item name and value
    screen.move(10, y_pos)
    screen.text(item.name)
    screen.move(100, y_pos)
    screen.text_right(tostring(params:get(item.param)))
  end
  
  screen.update()
end

function redraw()
  if in_menu then
    draw_menu()
    return
  end
  
  screen.clear()
  screen.font_size(8)

  local current_data = get_current_page_data()
  local page = page_data[current_page]

  -- Instrument and page title
  local title = instruments[selected_instrument].name.." "..page.title
  screen.move(100 - (#title * 4), 8)
  screen.text_center(title)

  -- Parameter slots
  for i = 1, 4 do
    draw_slot(i, current_data, 2, 15 + (i - 1) * 10)
  end
  for i = 5, 8 do
    draw_slot(i, current_data, 68, 15 + (i - 5) * 10)
  end

  -- Footer
  screen.move(84, 60)
  screen.text("K3: Roll")
  screen.move(44, 60)
  screen.text(string.format("%s ", page.title)) --  :%02d %s" , selected_instrument, instruments[selected_instrument].name))
  screen.move(4, 60)
  if edit_mode == "cc" then
    screen.text("CC")
  elseif edit_mode == "value" then
    screen.text("VAL")
  end

  screen.update()
end

function draw_slot(i, data, x, y)
  local marker = (selected_slot == i) and ">" or " "
  local cc = data.cc_targets[i]
  local cc_str = (cc == -1) and "OFF " or string.format("CC%03d", cc)
  screen.move(x, y)
  screen.text(string.format("%s%d: %s→%3d", marker, i, cc_str, data.cc_values[i]))
end

function redraw_loop()
  while true do
    redraw()
    clock.sleep(1/15)
  end
end
