{ pkgs, ... }:

let
  # Define the script using writeScriptBin with patchShebangs
  wt-link-shared-script = (pkgs.writeScriptBin "wt-link-shared" (builtins.readFile ./wt-link-shared.sh)).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  
  # Define dependencies the script needs
  wt-link-shared-deps = with pkgs; [
    coreutils  # for basename, rm, ln
    findutils  # for find operations
  ];
  
  # Create the final package with dependencies
  wt-link-shared = pkgs.symlinkJoin {
    name = "wt-link-shared";
    paths = [ wt-link-shared-script ] ++ wt-link-shared-deps;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/wt-link-shared \
        --prefix PATH : ${pkgs.lib.makeBinPath wt-link-shared-deps}
    '';
  };
in
{
  home.packages = [
    wt-link-shared
  ];
}