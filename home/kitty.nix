{ pkgs, ... }:
{

  programs.kitty.enable = true;
  programs.kitty = {
    font = {
      name = "PragmataPro Mono Liga";
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
      include ${pkgs.vimPlugins.onenord-nvim.src}/extras/kitty/onenord.conf
    '';
  };

  xdg.configFile."kitty/neighboring_window.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/neighboring_window.py";
  xdg.configFile."kitty/pass_keys.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/pass_keys.py";
}
