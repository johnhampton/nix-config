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
                  -- OneNord blue
                  color = { fg = "#81A1C1" },
                  -- Alternative OneNord colors:
                  -- color = { fg = "#88C0D0" }, -- cyan
                  -- color = { fg = "#B988B0" }, -- purple  
                  -- color = { fg = "#4C566A" }, -- subtle gray
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
