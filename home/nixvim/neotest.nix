{ ... }: {
  programs.nixvim = {
    plugins.neotest = {
      enable = true;
      settings.log_level = "trace";
      adapters.haskell.enable = true;
    };

    plugins.which-key = {
      registrations = {
        "<leader>t" = { name = "Test"; };
      };
    };

    keymaps = [
      {
        key = "<leader>tt";
        action = "<cmd>lua require('neotest').run.run()<cr>";
        mode = "n";
        options = { desc = "Run nearest test"; };
      }
      {
        key = "<leader>tf";
        action = ''<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>'';
        mode = "n";
        options = { desc = "Run all tests in current file"; };
      }
      {
        key = "<leader>to";
        action = "<cmd>lua require('neotest').output.open({ enter = true })<cr>";
        mode = "n";
        options = { desc = "Open test output window"; };
      }
      {
        key = "<leader>ts";
        action = "<cmd>lua require('neotest').summary.toggle()<cr>";
        mode = "n";
        options = { desc = "Toggle test summary"; };
      }
      {
        key = "<leader>ta";
        action = "<cmd>lua require('neotest').run.attach()<cr>";
        mode = "n";
        options = { desc = "Attach to running test"; };
      }
    ];
  };
}
