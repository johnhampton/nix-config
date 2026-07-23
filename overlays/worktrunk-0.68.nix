{ inputs, ... }:
# WORKAROUND(2026-07-23): nixpkgs still packages worktrunk 0.66.0, but we need
# 0.68.0. Bump version + source, and re-vendor the cargo deps with the 0.68.0
# hash. Drop this overlay once nixpkgs ships worktrunk >= 0.68.0.
# See docs/nix-workarounds.md.
final: prev: {
  worktrunk = prev.worktrunk.overrideAttrs (
    finalAttrs: old: {
      version = "0.68.0";

      src = final.fetchFromGitHub {
        owner = "max-sixty";
        repo = "worktrunk";
        tag = "v${finalAttrs.version}";
        hash = "sha256-4mxWRNNrpM5Fo49Xm8ypzBS15Y8kPPFd1iPod1RwxjA=";
      };

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        name = "worktrunk-${finalAttrs.version}-vendor";
        hash = "sha256-ZEv3peP/mjDDWYw4LNuhIt8I806W/yfUKtEA7e3t7rA=";
      };

      # These 0.68.0 unit tests probe live process names/PIDs, which the Nix
      # build sandbox doesn't expose (same reason the base package skips its
      # integration tests).
      checkFlags = (old.checkFlags or [ ]) ++ [
        "--skip=shell::utils::tests::test_probe_reports_invoked_name_for_sh"
        "--skip=shell::utils::tests::test_process_name_and_ppid_self"
      ];
    }
  );
}
