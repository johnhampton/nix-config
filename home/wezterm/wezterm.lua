local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.use_cap_height_to_scale_fallback_fonts = true;
config.font = wezterm.font 'PragmataPro Mono Liga'
config.font_size = 15.0
config.window_frame = {
  font = wezterm.font { family = 'PragmataPro Mono Liga', weight = 'Bold' },
  font_size = 14.5,
}

config.color_scheme = 'OneNord'
-- config.use_fancy_tab_bar = false
-- config.window_decorations = 'RESIZE'
-- config.warn_about_missing_glyphs = false

config.front_end = 'WebGpu'

config.hide_tab_bar_if_only_one_tab = true

config.mouse_bindings = {
   -- and make CTRL-Click open hyperlinks
  {
    event={Up={streak=1, button="Left"}},
    mods="CTRL",
    action=act.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
}

config.enable_kitty_keyboard = true
config.keys = {
  -- Disable Alt+Enter default binding to allow pass-through
  {
    key = 'Enter',
    mods = 'ALT',
    action = act.DisableDefaultAssignment,
  },
  -- Toggle fullscreen with Hyper+Enter (CMD+SHIFT+CTRL+ALT+Enter)
  {
    key = 'Enter',
    mods = 'CMD|SHIFT|CTRL|ALT',
    action = act.ToggleFullScreen,
  },
  {
    key = "Delete",
    action = wezterm.action.SendKey { key = "Delete" },
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action{SendString="\x1b\r"}
  },
  {
    key = 'j',
    mods = 'CMD',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = 'j' },
    },
  },
  {
    key = 'g',
    mods = 'CMD',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = 'G' },
    },
  },
  -- Map cmd-shift-[1-9] to tmux ctrl-a [1-9]
  -- Using the shifted characters (!, @, #, etc.) since Shift+number produces these
  {
    key = '!',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '1' },
    },
  },
  {
    key = '@',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '2' },
    },
  },
  {
    key = '#',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '3' },
    },
  },
  {
    key = '$',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '4' },
    },
  },
  {
    key = '%',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '5' },
    },
  },
  {
    key = '^',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '6' },
    },
  },
  {
    key = '&',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '7' },
    },
  },
  {
    key = '*',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '8' },
    },
  },
  {
    key = '(',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '9' },
    },
  },
  -- Move WezTerm tabs with CMD+CTRL+,/.
  {
    key = ',',
    mods = 'CMD|CTRL',
    action = act.MoveTabRelative(-1),
  },
  {
    key = '.',
    mods = 'CMD|CTRL',
    action = act.MoveTabRelative(1),
  },
  -- Move tmux windows with CMD+SHIFT+,/. (which produces < and >)
  {
    key = '<',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '<' },
    },
  },
  {
    key = '>',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'a', mods='CTRL' },
      act.SendKey { key = '>' },
    },
  },
}

-- Bell notification handler
-- Triggers a system notification when a bell character is received
wezterm.on('bell', function(window, pane)
  local title = pane:get_title()
  window:toast_notification(
    'Terminal Bell', 
    'Bell from: ' .. title, 
    nil, 
    4000
  )
end)

return config
