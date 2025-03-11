{pkgs, ... }:
{
  programs.wezterm.enable = true;
  programs.wezterm.extraConfig = ''
    local wezterm = require 'wezterm'
    local act = wezterm.action

    local config = {}

    config.use_cap_height_to_scale_fallback_fonts = true;
    config.font = wezterm.font 'PragmataPro Mono Liga'
    config.font_size = 15.0

    config.color_scheme = 'OneNord'
    config.use_fancy_tab_bar = false
    config.window_decorations = 'RESIZE'
    config.warn_about_missing_glyphs = false

    config.front_end = 'WebGpu'

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
      -- Disable Alt+Enter default binding to allow pass-through
      {
        key = 'Enter',
        mods = 'ALT',
        action = act.DisableDefaultAssignment,
      },
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

  xdg.configFile."wezterm/colors/onenord.toml".source = "${pkgs.vimPlugins.onenord-nvim.src}/extras/wezterm/onenord.toml";
  xdg.configFile."wezterm/colors/onenord_light.toml".source = "${pkgs.vimPlugins.onenord-nvim.src}/extras/wezterm/onenord_light.toml";
}
