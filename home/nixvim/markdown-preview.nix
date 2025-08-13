# Markdown Preview Plugin Configuration
# 
# Documentation:
# - NixVim: https://nix-community.github.io/nixvim/plugins/markdown-preview/
# - Plugin: https://github.com/iamcco/markdown-preview.nvim
#
# Provides live preview of markdown files in browser with synchronized scrolling,
# KaTeX math rendering, mermaid diagrams, and more.

{ ... }:
{
  programs.nixvim = {
    plugins.markdown-preview = {
      enable = true;
      
      settings = {
        auto_start = 0;  # Don't auto-start preview
        auto_close = 1;  # Auto-close when switching buffers
        refresh_slow = 0;  # Real-time refresh
        theme = "dark";  # Match your dark theme
        echo_preview_url = 1;  # Show URL in command line
        
        preview_options = {
          disable_sync_scroll = 0;  # Enable sync scroll
          sync_scroll_type = "middle";
          hide_yaml_meta = 1;  # Hide YAML frontmatter
        };
      };
    };
    
    keymaps = [
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options.desc = "Toggle Markdown Preview";
      }
      {
        mode = "n";
        key = "<leader>ms";
        action = "<cmd>MarkdownPreviewStop<cr>";
        options.desc = "Stop Markdown Preview";
      }
    ];
  };
}