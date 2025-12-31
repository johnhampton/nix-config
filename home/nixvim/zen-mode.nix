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
          tmux = {
            enabled = true;
          };
          twilight = {
            enabled = true;
          };
          wezterm = {
            enabled = true;
            font = "+1";
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
