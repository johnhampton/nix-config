{ ... }: {
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
    plugins.copilot-chat = {
      enable = true;
      settings = {
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
          CommitStaged = {
            mapping = "<leader>ac";
            description = "AI Generate Commit";
          };
        };
      };
    };
    plugins.copilot-lua = {
      enable = true;
      suggestion = {
        autoTrigger = true;
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

        require("CopilotChat.integrations.cmp").setup()
      end
    '';
  };
}

