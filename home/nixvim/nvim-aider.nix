{ pkgs, inputs, ... }: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-aider";
        version = inputs.nvim-aider.lastModifiedDate;
        src = inputs.nvim-aider;
      })
    ];

    keymaps = [
      {
        key = "<leader>a/";
        action = "<cmd>AiderTerminalToggle<cr>";
        options = {
          desc = "Open Aider";
        };
      }
      {
        key = "<leader>as";
        action = "<cmd>AiderTerminalSend<cr>";
        options = {
          desc = "Send to Aider";
        };
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>ac";
        action = "<cmd>AiderQuickSendCommand<cr>";
        options = {
          desc = "Send Command To Aider";
        };
      }
      {
        key = "<leader>ab";
        action = "<cmd>AiderQuickSendBuffer<cr>";
        options = {
          desc = "Send Buffer To Aider";
        };
      }
      {
        key = "<leader>a+";
        action = "<cmd>AiderQuickAddFile<cr>";
        options = {
          desc = "Add File to Aider";
        };
      }
      {
        key = "<leader>a-";
        action = "<cmd>AiderQuickDropFile<cr>";
        options = {
          desc = "Drop File from Aider";
        };
      }
      {
        key = "<leader>ar";
        action = "<cmd>AiderQuickReadOnlyFile<cr>";
        options = {
          desc = "Add File as Read-Only";
        };
      }
      {
        key = "<leader>a+";
        action = "<cmd>AiderTreeAddFile<cr>";
        options = {
          desc = "Add File from Tree to Aider";
          ft = "NvimTree";
        };
      }
      {
        key = "<leader>a-";
        action = "<cmd>AiderTreeDropFile<cr>";
        options = {
          desc = "Drop File from Tree from Aider";
          ft = "NvimTree";
        };
      }
    ];
  };
}
