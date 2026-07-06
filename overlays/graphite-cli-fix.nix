# Temporary fix: graphite-cli 1.8.6's Darwin build generates shell completions
# by running `gt completion`, which produces empty output and makes
# installShellCompletion fail ("gt.bash ... does not exist or has zero size").
# Drop the completion generation; the `gt` binary itself is unaffected.
{ inputs, ... }:
final: prev: {
  graphite-cli = prev.graphite-cli.overrideAttrs (old: {
    postInstall = "";
  });
}
