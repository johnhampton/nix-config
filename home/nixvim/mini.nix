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
        action = "<cmd>lua MiniFiles.open()<cr>";
        options = {
          desc = "Explore";
        };
      }
      {
        mode = "n";
        key = "<leader>E";
        action = "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>";
        options = {
          desc = "Explore current file";
        };
      }
    ];
  };
}
