{ pkgs, ... }:
{

  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      sections = {
        lualine_c = [
          "filename"
          "lsp_progress"
        ];
      };
    };

    extraPlugins = [ pkgs.vimPlugins.lualine-lsp-progress ];
  };
}
