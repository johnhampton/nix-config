{ pkgs, ... }: {

  programs.nixvim = {
    plugins = {
      conform-nvim = {
        enable = true;

        formatters = {
          black = {
            append_args = [ "--fast" ];
          };
        };

        formattersByFt = {
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          javascriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          css = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          html = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          json = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          graphql = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          markdown = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          lua = [ "stylua" ];
          python = [ "black" ];
          sql = [ "pg_format" ];
          yaml = [ "yamlfmt" ];
        };
      };
    };

    keymaps = [
      {
        mode = [ "n" "v" ];
        key = "<leader>lf";
        action = {
          __raw = ''function()
                    require("conform").format({
                      lsp_format = "fallback",
                      async = false,
                      timeout_ms = 2000,
                    })
                    end'';
        };
        options = {
          desc = "Format file or range (in visual mode)";
        };
      }
    ];
  };

  home.packages = with pkgs; [
    black
    pgformatter
    nodePackages.prettier
    prettierd
    stylua
    yamlfmt
  ];
}
