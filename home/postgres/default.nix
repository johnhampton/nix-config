{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.pspg
    pkgs.postgresql
  ];

  home.sessionVariables = {
    PSPG_CONF="${config.xdg.configHome}/pspg/pspg.conf";
  };

  xdg.configFile."pspg/pspg.conf".text = ''
    # Configuration file for pspg
    #
    custom_theme_name = onenord
  '';
  xdg.configFile."pspg/.pspg_theme_onenord".source = ./pspg_theme_onenord;

  home.file.".psqlrc".text = ''
    -- Use pspg as pager
    \setenv PAGER 'pspg'

    -- Recommended settings for psql
    \set QUIET 1
    \pset linestyle unicode
    \pset border 2
    \pset null ∅
    \unset QUIET
  '';
}

