{ ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        basics = { };
        bufremove = { };
        diff = { };
        files = { };
        git = { };
        jump = { };
        surround = { };
      };
    };

    plugins.which-key = {
      registrations = {
        "<leader>b" = { name = "Buffer"; };
        "<leader>g" = { name = "Git"; };
      };
    };



    autoCmd = [
      {
        event = "User";
        pattern = "MiniFilesBufferCreate";
        callback = {
          __raw = ''
            function(args)
              local buf_id = args.data.buf_id

              vim.keymap.set('n', '-', MiniFiles.go_out, { buffer = buf_id, desc = "Go out" })
            end
          '';
        };
      }
      {
        event = "User";
        pattern = "MiniFilesBufferCreate";
        callback = {
          __raw = ''
            function(args)
              local map_split = function(buf_id, lhs, direction)
                local rhs = function()
                  -- Make new window and set it as target
                  local new_target_window
                  vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
                    vim.cmd(direction .. ' split')
                    new_target_window = vim.api.nvim_get_current_win()
                  end)

                  MiniFiles.set_target_window(new_target_window)
                end

                -- Adding `desc` will result into `show_help` entries
                local desc = 'Split ' .. direction
                vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
              end

              local buf_id = args.data.buf_id

              -- Tweak keys to your liking
              map_split(buf_id, 'gs', 'belowright horizontal')
              map_split(buf_id, 'gv', 'belowright vertical')
            end
          '';
        };
      }
    ];

    keymaps = [
      # File explorer
      {
        mode = "n";
        key = "<leader>e";
        action = {
          __raw = ''
            function () 
              if not MiniFiles.close() then MiniFiles.open() end
            end
          '';
        };
        options = {
          desc = "Explore";
        };
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>";
        options = {
          desc = "Explore directory of current file";
        };
      }
      {
        mode = "n";
        key = "<leader>E";
        action = "<cmd>lua MiniFiles.open(nil, false)<cr>";
        options = {
          desc = "Fresh explorer";
        };
      }

      # Buffer remove
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>lua MiniBufremove.delete()<cr>";
        options = {
          desc = "Delete buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bw";
        action = "<cmd>lua MiniBufremove.wipeout()<cr>";
        options = {
          desc = "Wipeout buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bh";
        action = "<cmd>lua MiniBufremove.unshow()<cr>";
        options = {
          desc = "Hide buffer";
        };
      }

      # Git
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>lua MiniDiff.toggle_overlay()<cr>";
        options = {
          desc = "Toggle git overlay";
        };
      }
      {
        mode = [ "n" "x" ];
        key = "<leader>gs";
        action = "<cmd>lua MiniGit.show_at_cursor()<cr>";
        options = {
          desc = "Show at cursor";
        };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = "<cmd>Telescope git_status<cr>";
        options = {
          desc = "Changed files";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Telescope git_branches<cr>";
        options = {
          desc = "Branches";
        };
      }
    ];
  };
}
