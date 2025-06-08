{ ... }: {
  # sesh dependencies are handled by the module itself
  # we already have fd, fzf, and zoxide in the system

  programs.sesh = {
    enable = true;
    tmuxKey = "j"; # Use prefix + j instead of default prefix + s
    # enableAlias = true; # default, provides 's' shell alias
    # enableTmuxIntegration = true; # default
    # icons = true; # default
  };
}
