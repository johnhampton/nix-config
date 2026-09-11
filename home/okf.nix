{ pkgs, ... }:

{
  home.packages = [ pkgs.okf ];

  home.file.".zfunc/_okf".source = pkgs.runCommand "okf-zsh-completions" { } ''
    ${pkgs.okf}/bin/okf completions zsh > $out
  '';
}
