{ ... }: {
  programs.nixvim = {
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
      		end 
      	'';
  };
}
