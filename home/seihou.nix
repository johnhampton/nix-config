{ pkgs, ... }:

{
  home.packages = [ pkgs.seihou ];

  home.file.".zfunc/_seihou".source = pkgs.runCommand "seihou-zsh-completions" { } ''
    ${pkgs.seihou}/bin/seihou completions zsh > $out
  '';
}
