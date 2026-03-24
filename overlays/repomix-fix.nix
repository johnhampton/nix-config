{ inputs, ... }:
final: prev: {
  repomix = prev.repomix.overrideAttrs (old: {
    doCheck = false;
  });
}
