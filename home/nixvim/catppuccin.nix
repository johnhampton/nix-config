{ ... }:

{

  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        # Pin the flavour; the default is "auto", which follows vim.o.background
        # and would fall through to latte whenever background=light.
        flavour = "mocha";

        # Catppuccin's default Comment colour (overlay0, #6c7086) measures 3.36:1
        # against base — under the 4.5:1 WCAG AA floor. overlay2 lifts it to
        # 5.81:1 and still reads as de-emphasised next to text at 11.34:1.
        custom_highlights.__raw = ''
          function(colors)
            return {
              Comment = { fg = colors.overlay2 },
            }
          end
        '';
      };
    };

    # Inert while lspsaga stays disabled, but carried over from the onenord config
    # so the mapping still holds if it is ever enabled.
    plugins.lspsaga.settings.ui.kind.__raw =
      "require('catppuccin.groups.integrations.lsp_saga').custom_kind()";

    plugins.lualine.settings.theme = "catppuccin";
  };
}
