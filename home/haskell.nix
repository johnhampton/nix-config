{ pkgs, ... } : 
{
  home.packages = [
    pkgs.haskellPackages.cabal-fmt
    pkgs.haskellPackages.cabal-gild
    pkgs.haskellPackages.fourmolu
    pkgs.cabal-install
    pkgs.ghc
    pkgs.ghcid
    pkgs.haskell-language-server
  ];
}

