{ ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        basics = { };
        bufremove = { };
        files = { };
        jump = { };
        surround = { };
      };
    };

    plugins.which-key = {
      registrations = {
        "<leader>b" = { name = "Buffer"; };
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
        action = "<cmd>lua MiniBufRemove.delete()<cr>";
        options = {
          desc = "Delete buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bw";
        action = "<cmd>lua MiniBufRemove.wipeout()<cr>";
        options = {
          desc = "Wipeout buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bh";
        action = "<cmd>lua MiniBufRemove.unshow()<cr>";
        options = {
          desc = "Hide buffer";
        };
      }
    ];
  };
}
