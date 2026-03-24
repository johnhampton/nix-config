{ inputs, ... }:
final: prev: prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  folly = prev.folly.overrideAttrs (old: {
    doCheck = false;
  });
}
