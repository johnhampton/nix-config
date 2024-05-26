{ pkgs, ... }: {
  programs.vscode.enable = true;
  programs.vscode = {
    extensions =
      let
        v = pkgs.vscode-extensions;
      in
      [
        v.vscodevim.vim
        v.haskell.haskell
        v.justusadam.language-haskell
      ];
  };
}
