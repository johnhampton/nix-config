{ pkgs, ... }:
{

  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      settings = {
        sections = {
          lualine_c = [
            "filename"
            "lsp_progress"
          ];
          lualine_x = [
            {
              __raw = ''
                {
                  function()
                    if vim.v.this_session and vim.v.this_session ~= "" then
                      local session_name = vim.fn.fnamemodify(vim.v.this_session, ":t")
                      local is_local = session_name == "Session.vim"
                      local icon = is_local and "" or ""
                      return icon .. " " .. session_name
                    end
                    return ""
                  end,
                  -- Catppuccin Mocha blue
                  color = { fg = "#89b4fa" },
                  -- Alternative Catppuccin Mocha colors:
                  -- color = { fg = "#89dceb" }, -- sky
                  -- color = { fg = "#cba6f7" }, -- mauve
                  -- color = { fg = "#9399b2" }, -- subtle gray (overlay2)
                }
              '';
            }
            "encoding"
            "fileformat"
            "filetype"
          ];
        };
      };
    };

    extraPlugins = [ pkgs.vimPlugins.lualine-lsp-progress ];
  };
}
