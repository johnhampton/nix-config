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

    plugins.copilot-chat = {
      enable = true;
      settings = {
        chat_autocomplete = true;
        mappings = {
          complete = {
            insert = "";
          };
        };

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
            prompt = "Write a concise commit message for the change using the commitizen convention. Ensure the title is no longer than 50 characters, and the body (if needed) is wrapped at 72 characters. Keep the message simple, clear, and to the point. Wrap the entire message in a code block with the language set to gitcommit.";
          };
          CommitStaged = {
            mapping = "<leader>ac";
            description = "AI Generate Commit";
            prompt = "Write a concise commit message for the change using the commitizen convention. Ensure the title is no longer than 50 characters, and the body (if needed) is wrapped at 72 characters. Keep the message simple, clear, and to the point. Wrap the entire message in a code block with the language set to gitcommit.";
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

