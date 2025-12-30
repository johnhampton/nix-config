{ ... }:
{
  programs.nixvim = {
    plugins.twilight.enable = true;

    plugins.zen-mode = {
      enable = true;
      settings = {
        window = {
          width = 0.85;
        };
        plugins = {
          twilight = {
            enabled = true;
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>z";
        action = "<cmd>ZenMode<cr>";
        options = {
          desc = "Toggle Zen Mode";
          silent = true;
        };
      }
    ];
  };
}
