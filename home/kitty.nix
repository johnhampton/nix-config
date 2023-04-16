{ pkgs, ... }:
let
  font_features = (features: builtins.concatStringsSep "\n" (map (f: "font_features ${f} ${features}")
    [
      "IosevkaNerdFontComplete-Bold"
      "IosevkaNerdFontComplete-BoldItalic"
      "IosevkaNerdFontComplete-ObliqueBold"
      "IosevkaNerdFontComplete-ExtraBold"
      "IosevkaNerdFontComplete-ExtraBoldItalic"
      "IosevkaNerdFontComplete-ExtraBoldOblique"
      "IosevkaNerdFontComplete-ExtraLight"
      "IosevkaNerdFontComplete-ExtraLightItalic"
      "IosevkaNerdFontComplete-ExtraLightOblique"
      "IosevkaNerdFontComplete-Heavy"
      "IosevkaNerdFontComplete-HeavyItalic"
      "IosevkaNerdFontComplete-HeavyOblique"
      "IosevkaNerdFontComplete-Italic"
      "IosevkaNerdFontComplete-Light"
      "IosevkaNerdFontComplete-LightItalic"
      "IosevkaNerdFontComplete-LightOblique"
      "IosevkaNerdFontComplete-Medium"
      "IosevkaNerdFontComplete-MediumItalic"
      "IosevkaNerdFontComplete-MediumOblique"
      "IosevkaNerdFontComplete-Oblique"
      "IosevkaNerdFontComplete"
      "IosevkaNerdFontComplete-SemiBold"
      "IosevkaNerdFontComplete-SemiBoldItalic"
      "IosevkaNerdFontComplete-SemiBoldOblique"
      "IosevkaNerdFontComplete-Thin"
      "IosevkaNerdFontComplete-ThinItalic"
      "IosevkaNerdFontComplete-ThinOblique"
    ]));
in
{

  programs.kitty.enable = true;
  programs.kitty = {
    font = {
      name = "PragmataPro Liga";
      size = 14;
    };
    settings = {
      allow_remote_control = "yes";
      enabled_layouts = "splits,tall:bias=70,fat:bias=70,stack";
      listen_on = "unix:/tmp/mykitty";
      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "yes";
      tab_bar_style = "powerline";
      tab_title_template = ''{index}:{title}{"*Z" if layout_name == "stack" else ""}'';
      update_check_interval = 0;
    };
    extraConfig = ''
      ${font_features "-calt +HSKL"}

      include ${pkgs.vimPlugins.onenord-nvim.src}/extras/kitty/onenord.conf
    '';
  };

  xdg.configFile."kitty/neighboring_window.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/neighboring_window.py";
  xdg.configFile."kitty/pass_keys.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/pass_keys.py";
}
