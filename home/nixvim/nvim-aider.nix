{ pkgs, inputs, ... }: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-aider";
        version = inputs.nvim-aider.lastModifiedDate;
        src = inputs.nvim-aider;
        dependencies = [
          pkgs.vimPlugins.snacks-nvim
        ];
      })
    ];

    keymaps = [
      {
        key = "<leader>A/";
        action = "<cmd>AiderTerminalToggle<cr>";
        options = {
          desc = "Open Aider";
        };
      }
      {
        key = "<leader>As";
        action = "<cmd>AiderTerminalSend<cr>";
        options = {
          desc = "Send to Aider";
        };
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>Ac";
        action = "<cmd>AiderQuickSendCommand<cr>";
        options = {
          desc = "Send Command To Aider";
        };
      }
      {
        key = "<leader>Ab";
        action = "<cmd>AiderQuickSendBuffer<cr>";
        options = {
          desc = "Send Buffer To Aider";
        };
      }
      {
        key = "<leader>A+";
        action = "<cmd>AiderQuickAddFile<cr>";
        options = {
          desc = "Add File to Aider";
        };
      }
      {
        key = "<leader>A-";
        action = "<cmd>AiderQuickDropFile<cr>";
        options = {
          desc = "Drop File from Aider";
        };
      }
      {
        key = "<leader>Ar";
        action = "<cmd>AiderQuickReadOnlyFile<cr>";
        options = {
          desc = "Add File as Read-Only";
        };
      }
    ];

    files = {
      "after/ftplugin/NvimTree.lua" = {
        keymaps = [
          {
            key = "<leader>A+";
            action = "<cmd>AiderTreeAddFile<cr>";
            options = {
              desc = "Add File from Tree to Aider";
            };
          }
          {
            key = "<leader>A-";
            action = "<cmd>AiderTreeDropFile<cr>";
            options = {
              desc = "Drop File from Tree from Aider";
            };
          }
        ];
      };
    };
    plugins.snacks.enable = true;
    extraConfigLua = ''
      require("nvim_aider").setup({});
    '';
  };
}
