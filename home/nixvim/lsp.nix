{ ... }: {
  programs.nixvim = {
    plugins.nvim-lightbulb = {
      enable = true;
      settings = {
        autocmd.enabled = true;
      };
    };
    plugins.lsp = {
      enable = true;

      servers = {
        nil-ls = { enable = false; };
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixpkgs-fmt" ];
        };

        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings = {
            files = {
              excludeDirs = [ ".direnv" ".devenv" ];
            };
          };
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
          "<leader>ca" = {
            action = "code_action";
            desc = "Code Action";
          };
          "<F2>" = {
            action = "rename";
            desc = "Rename";
          };
        };

        extra = [
          {
            key = "<leader>cl";
            action = "<cmd>lua vim.lsp.codelens.run()<cr>";
            options = {
              desc = "CodeLens Action";
            };
          }
          {
            key = "<leader>cr";
            action = "<cmd>lua vim.lsp.codelens.refresh()<cr>";
            options = {
              desc = "Refresh CodeLens";
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

          # LSP Diagnostics
          {
            key = "<leader>ld";
            action = "<cmd>lua require'telescope.builtin'.diagnostics({ bufnr = 0 })<cr>";
            options = {
              desc = "Document Diagnostics";
            };
          }
          {
            key = "<leader>lw";
            action = "<cmd>lua require'telescope.builtin'.diagnostics()<cr>";
            options = {
              desc = "Workspace Diagnostics";
            };
          }

          # LSP Symbols
          {
            key = "<leader>ls";
            action = "<cmd>lua require'telescope.builtin'.lsp_document_symbols()<cr>";
            options = {
              desc = "Document Symbols";
            };
          }
          {
            key = "<leader>lS";
            action = "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<cr>";
            options = {
              desc = "Workspace Symbols";
            };
          }
          {
            key = "<leader>Li";
            action = "<cmd>LspInfo<cr>";
            options = {
              desc = "LSP info";
            };
          }
          {
            key = "<leader>Lx";
            action = "<cmd>LspStop<cr>";
            options = {
              desc = "Stop LSP";
            };
          }
          {
            key = "<leader>Ls";
            action = "<cmd>LspStart<cr>";
            options = {
              desc = "Start LSP";
            };
          }
          {
            key = "<leader>Lr";
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
