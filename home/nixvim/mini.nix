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
      settings = {
        spec = [
          { __unkeyed-1 = "<leader>b"; group = "Buffer"; }
          { __unkeyed-1 = "<leader>g"; group = "Git"; }
        ];
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
                  local cur_target = MiniFiles.get_explorer_state().target_window
                  local new_target = vim.api.nvim_win_call(cur_target, function()
                    vim.cmd(direction .. ' split')
                    return vim.api.nvim_get_current_win()
                  end)

                  MiniFiles.set_target_window(new_target)

                  -- This intentionally doesn't act on file under cursor in favor of
                  -- explicit "go in" action (`l` / `L`). To immediately open file,
                  -- add appropriate `MiniFiles.go_in()` call instead of this comment.
                end

                -- Adding `desc` will result into `show_help` entries
                local desc = 'Split ' .. direction
                vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
              end

              local buf_id = args.data.buf_id
              
              -- Tweak keys to your liking
              map_split(buf_id, '<C-x>', 'belowright horizontal')
              map_split(buf_id, '<C-v>', 'belowright vertical')
              map_split(buf_id, '<C-t>', 'tab')
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
              -- Set focused directory as current working directory
              local set_cwd = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                vim.fn.chdir(vim.fs.dirname(path))
              end

              -- Yank in register relative path of entry under cursor
              local yank_relative_path = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                local rel_path = vim.fn.fnamemodify(path, ":~:.")
                vim.fn.setreg(vim.v.register, rel_path)
              end

              -- Yank in register full path of entry under cursor
              local yank_full_path = function()
                local path = (MiniFiles.get_fs_entry() or {}).path
                if path == nil then return vim.notify('Cursor is not on valid entry') end
                vim.fn.setreg(vim.v.register, path)
              end

              -- Open path with system default handler (useful for non-text files)
              local ui_open = function() vim.ui.open(MiniFiles.get_fs_entry().path) end

              local b = args.data.buf_id
              vim.keymap.set('n', 'g~', set_cwd,           { buffer = b, desc = 'Set cwd' })
              vim.keymap.set('n', 'gX', ui_open,           { buffer = b, desc = 'OS open' })
              vim.keymap.set('n', 'gy', yank_relative_path, { buffer = b, desc = 'Yank relative path' })
              vim.keymap.set('n', 'gY', yank_full_path,     { buffer = b, desc = 'Yank full path' })
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
