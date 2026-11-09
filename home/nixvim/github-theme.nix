{ ... }:

{
  programs.nixvim = {
    # Matches Rex's "Merino Dark" theme, which uses GitHub's Dark Default
    # palette (bg #0d1117, fg #e6edf3).
    colorschemes.github-theme.enable = true;

    # The nixvim module defaults to "github_dark", whose palette differs from
    # Rex's. Comments (#8b949e) measure ~6.2:1 against the background, above the
    # WCAG AA 4.5:1 floor, so no Comment override is needed.
    colorscheme = "github_dark_default";

    # github-nvim-theme has no named lualine theme; "auto" derives one from the
    # active highlight groups.
    plugins.lualine.settings.theme = "auto";
  };
}
