{ ... }:
{
  programs.wezterm.enable = true;
  programs.wezterm.extraConfig = ''
    local wezterm = require 'wezterm'
    local act = wezterm.action

    local config = {}

    config.use_cap_height_to_scale_fallback_fonts = true;
    config.font = wezterm.font 'PragmataPro Mono Liga'
    config.font_size = 14.0

    config.color_scheme = 'nordfox'
    -- config.window_decorations = 'RESIZE'

    config.hide_tab_bar_if_only_one_tab = true

    config.mouse_bindings = {
       -- and make CTRL-Click open hyperlinks
      {
        event={Up={streak=1, button="Left"}},
        mods="CTRL",
        action="OpenLinkAtMouseCursor",
      },
      -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
      {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.Nop,
      },
    }

    config.keys = {
      {
        key = 'j',
        mods = 'CMD',
        action = act.Multiple {
          act.SendKey { key = 'a', mods='CTRL' },
          act.SendKey { key = 'T' },
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
    }

    return config
  '';
}
