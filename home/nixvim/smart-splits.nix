{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
    };

    keymaps = [
      # Navigation keymaps
      {
        mode = "n";
        key = "<C-h>";
        action = "<cmd>lua require('smart-splits').move_cursor_left()<cr>";
        options = {
          desc = "Move to left split";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>lua require('smart-splits').move_cursor_down()<cr>";
        options = {
          desc = "Move to below split";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>lua require('smart-splits').move_cursor_up()<cr>";
        options = {
          desc = "Move to above split";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<cmd>lua require('smart-splits').move_cursor_right()<cr>";
        options = {
          desc = "Move to right split";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<C-\\>";
        action = "<cmd>lua require('smart-splits').move_cursor_previous()<cr>";
        options = {
          desc = "Move to previous split";
          silent = true;
        };
      }

      # Resizing keymaps
      {
        mode = "n";
        key = "<A-h>";
        action = "<cmd>lua require('smart-splits').resize_left()<cr>";
        options = {
          desc = "Resize split left";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>lua require('smart-splits').resize_down()<cr>";
        options = {
          desc = "Resize split down";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>lua require('smart-splits').resize_up()<cr>";
        options = {
          desc = "Resize split up";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-l>";
        action = "<cmd>lua require('smart-splits').resize_right()<cr>";
        options = {
          desc = "Resize split right";
          silent = true;
        };
      }

      # Buffer swapping keymaps
      {
        mode = "n";
        key = "<leader><leader>h";
        action = "<cmd>lua require('smart-splits').swap_buf_left()<cr>";
        options = {
          desc = "Swap buffer left";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader><leader>j";
        action = "<cmd>lua require('smart-splits').swap_buf_down()<cr>";
        options = {
          desc = "Swap buffer down";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader><leader>k";
        action = "<cmd>lua require('smart-splits').swap_buf_up()<cr>";
        options = {
          desc = "Swap buffer up";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader><leader>l";
        action = "<cmd>lua require('smart-splits').swap_buf_right()<cr>";
        options = {
          desc = "Swap buffer right";
          silent = true;
        };
      }
    ];
  };
}