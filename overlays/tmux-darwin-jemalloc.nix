{ inputs, ... }:
final: prev: {
  # WORKAROUND(2026-08-24): tmux 3.7c's configure refuses to proceed on macOS
  # unless jemalloc is explicitly enabled or disabled, and the nixos-unstable
  # tmux derivation passes neither — so the build dies with
  # "configure: error: must give --enable-jemalloc or --disable-jemalloc".
  # This mirrors the fix already in nixpkgs master (jemalloc buildInput +
  # --enable-jemalloc, both gated on darwin), which upstream chose over
  # --disable-jemalloc because macOS calloc(3) does not reliably zero
  # allocations.
  # Drop this once the locked nixpkgs ships a tmux whose configureFlags already
  # contain "--enable-jemalloc". See docs/nix-workarounds.md.
  tmux = prev.tmux.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ final.jemalloc ];
    configureFlags = (old.configureFlags or [ ]) ++ [ "--enable-jemalloc" ];
  });
}
