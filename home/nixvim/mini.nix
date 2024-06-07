{ ... }:
{
  programs. nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        basics = { };
        files = { };
        jump = { };
        surround = { };
      };
    };

    keymaps = [
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
    ];
  };
}
