{ ... }: {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      servers = {
        nil_ls = { enable = false; };
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixpkgs-fmt" ];
        };
      };
			
      keymaps = {
        diagnostic = {
          "gl" = {
            action = "open_float";
            desc = "Line diagnostics";
          };
        };
        lspBuf = {
          "<leader>lf" = {
            action = "format";
            desc = "Format";
          };

          "<leader>ca" = {
            action = "code_action";
            desc = "Code Action";
          };
        };

        extra = [
          {
            key = "<leader>cr";
            action = "<cmd>lua vim.lsp.codelens.run()<cr>";
            options = {
              desc = "CodeLens Action";
            };
          }
					{
						key = "gd";
						action = "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>";
						options = {
							 desc = "Goto Definition";
						};
					}
					{
						key = "gr";
						action = "<cmd>lua require'telescope.builtin'.lsp_references()<cr>";
						options = {
							 desc = "List References";
						};
					}
          {
            key = "<leader>li";
            action = "<cmd>LspInfo<cr>";
            options = {
              desc = "LSP info";
            };
          }
          {
            key = "<leader>lx";
            action = "<cmd>LspStop<cr>";
            options = {
              desc = "Stop LSP";
            };
          }
          {
            key = "<leader>ls";
            action = "<cmd>LspStart<cr>";
            options = {
              desc = "Start LSP";
            };
          }
          {
            key = "<leader>lr";
            action = "<cmd>LspRestart<cr>";
            options = {
              desc = "Restart LSP";
            };
          }
        ];
      };
    };
  };
}
