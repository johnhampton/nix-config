{ pkgs, ... }:

let
  # wt-link-shared script
  wt-link-shared-script = (pkgs.writeScriptBin "wt-link-shared" (builtins.readFile ./wt-link-shared.sh)).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  
  wt-link-shared-deps = with pkgs; [
    coreutils  # for basename, rm, ln
    findutils  # for find operations
  ];
  
  wt-link-shared = pkgs.symlinkJoin {
    name = "wt-link-shared";
    paths = [ wt-link-shared-script ] ++ wt-link-shared-deps;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/wt-link-shared \
        --prefix PATH : ${pkgs.lib.makeBinPath wt-link-shared-deps}
    '';
  };

  # wt-clone script
  wt-clone-script = (pkgs.writeScriptBin "wt-clone" (builtins.readFile ./wt-clone.sh)).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  
  wt-clone-deps = with pkgs; [
    git
    coreutils  # for cut, echo, mkdir
    gnused     # for sed
    gnugrep    # for grep
  ];
  
  wt-clone = pkgs.symlinkJoin {
    name = "wt-clone";
    paths = [ wt-clone-script ] ++ wt-clone-deps;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/wt-clone \
        --prefix PATH : ${pkgs.lib.makeBinPath wt-clone-deps}
    '';
  };
in
{
  home.packages = [
    wt-link-shared
    wt-clone
  ];
}
