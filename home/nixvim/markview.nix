# Markview Plugin Configuration
#
# Documentation:
# - NixVim: https://nix-community.github.io/nixvim/plugins/markview/
# - Plugin: https://github.com/OXY2DEV/markview.nvim
#
# In-buffer markdown/LaTeX/Typst/YAML/HTML rendering. Complements
# markdown-preview.nvim (browser) with inline preview and hybrid editing.
# Upstream explicitly recommends against lazy loading.

{ ... }:
{
  programs.nixvim = {
    plugins.markview = {
      enable = true;
      autoLoad = true;

      settings = {
        preview = {
          enable = true;
          enable_hybrid_mode = true;
          icon_provider = "devicons";
          modes = [ "n" "no" "c" ];
          hybrid_modes = [ "i" ];
          buf_ignore = [ "nofile" ];
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>mv";
        action = "<cmd>Markview Toggle<cr>";
        options.desc = "Toggle Markview (global)";
      }
      {
        mode = "n";
        key = "<leader>mh";
        action = "<cmd>Markview HybridToggle<cr>";
        options.desc = "Toggle Markview hybrid mode";
      }
      {
        mode = "n";
        key = "<leader>mS";
        action = "<cmd>Markview splitToggle<cr>";
        options.desc = "Toggle Markview splitview";
      }
      {
        mode = "n";
        key = "<leader>mr";
        action = "<cmd>Markview Render<cr>";
        options.desc = "Re-render Markview previews";
      }
    ];
  };
}
