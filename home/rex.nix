{ config, lib, ... }:
{
  # Follow the server selected by Rex's updater, including outside Rex terminals.
  home.file.".local/bin/rex".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex";

  # Nix and Homebrew reorder PATH during startup. Rex terminals must use the
  # CLI supplied by their server, ahead of the fallback in ~/.local/bin.
  # https://www.superlogical.com/rex/docs/automate/cli#path
  programs.zsh.initContent = lib.mkOrder 2000 ''
    if [ -n "$REX_BIN_DIR" ]; then
      export PATH="$REX_BIN_DIR:$PATH"
    fi
  '';
}
