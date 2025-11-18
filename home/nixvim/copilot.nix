{ pkgs, ... }: {
  programs.nixvim = {
    keymaps = [
      {
        mode = [ "n" "v" ];
        key = "<leader>aa";
        action = { __raw = ''require('CopilotChat').toggle''; };
        options = { desc = "AI Toggle"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>ax";
        action = { __raw = ''require('CopilotChat').reset''; };
        options = { desc = "AI Reset"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>ah";
        action = {
          __raw = ''
            function()
              local chat = require('CopilotChat')
              local actions = require('CopilotChat.actions')
              local pick = require('CopilotChat.integrations.telescope').pick

              pick(actions.help_actions())
            end
          '';
        };
        options = { desc = "AI Help Actions"; };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>ap";
        action = {
          __raw = ''
            function()
              local chat = require('CopilotChat')
              local actions = require('CopilotChat.actions')
              local pick = require('CopilotChat.integrations.telescope').pick

              pick(actions.prompt_actions())
            end
          '';
        };
        options = { desc = "AI Prompt Actions"; };
      }
    ];

    extraLuaPackages = p: [
      p.tiktoken_core
    ];
    extraPackages = [ pkgs.lynx ];

    plugins.copilot-chat = {
      enable = true;
      settings = {
        chat_autocomplete = true;
        mappings = {
          complete = {
            insert = "";
          };
        };

        model = "claude-sonnet-4.5";

        prompts = {
          Explain = {
            mapping = "<leader>ae";
            description = "AI Explain";
          };
          Review = {
            mapping = "<leader>ar";
            description = "AI Review";
          };
          Tests = {
            mapping = "<leader>at";
            description = "AI Tests";
          };
          Fix = {
            mapping = "<leader>af";
            description = "AI Fix";
          };
          Optimize = {
            mapping = "<leader>ao";
            description = "AI Optimize";
          };
          Docs = {
            mapping = "<leader>ad";
            description = "AI Documentation";
          };
          Commit = {
            mapping = "<leader>ac";
            description = "AI Generate Commit";
          };
        };
      };
    };

    plugins.copilot-lua = {
      enable = true;
      settings = {
        suggestion = {
          auto_trigger = true;
        };
      };
    };

    extraConfigLua = ''
      do
        local cmp = require("cmp")
        local copilot = require("copilot.suggestion")

        cmp.event:on("menu_opened", function()
          vim.b.copilot_suggestion_hidden = true
          if copilot.is_visible() then
            copilot.dismiss()
          end
        end)

        cmp.event:on("menu_closed", function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end
    '';
  };
}

