# Nix Workarounds

Temporary patches and overrides added to work around **upstream** breakage
(nixpkgs, nix-darwin, home-manager, flake inputs). Each entry is a candidate for
removal once upstream ships a fix.

**Check this file during every `nix-flake-upgrade`.** After the lock file is
updated but before merging, attempt to remove each workaround below and rebuild.
If the build still succeeds, upstream has fixed the issue — delete the workaround
in the same upgrade.

## How to add an entry

When you add a workaround, also:

1. Leave a `WORKAROUND(YYYY-MM-DD):` comment at the code site explaining the
   root cause and pointing back to this file.
2. Add a row here with enough detail to test removal later.

Keep the code comment and this file in sync; when you remove the workaround,
remove both.

## Active workarounds

### seihou-core: missing Hackage test assets

- **Added:** 2026-09-10
- **Root cause:** seihou-core 0.8.0.0 omits test/fixtures and schema from its Hackage archive; ScaffoldSpec loads schema/package.dhall and other suites load fixtures.
- **Workaround:** Disable only seihou-core tests; keep other package tests and verify the installed CLIs separately.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** A Hackage release includes both test/fixtures and schema/package.dhall. Remove its dontCheck wrapper and run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.


### cradle: stale broken marker

- **Added:** 2026-09-10
- **Root cause:** nixpkgs marks cradle 0.0.0.0 broken from a 2024 Hydra failure and refuses evaluation of the Baikai dependency. Its test harness also requires PYTHON_BIN_PATH, which the stock derivation does not set.
- **Workaround:** Clear that package's marker only inside the tools' GHC 9.12.4 sets; set PYTHON_BIN_PATH to the Nix Python interpreter and retain its tests to validate compatibility.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs no longer marks cradle broken and supplies the required test environment. Remove the cradle override and build both tools followed by `just build`.

### unicode-data: Unicode tables differ from GHC 9.12

- **Added:** 2026-09-10
- **Root cause:** unicode-data 0.6.0's Unicode 15.1 case-conversion tests fail against GHC 9.12's Unicode 16.0 tables (toUpper/toTitle on U+019B).
- **Workaround:** Pin Hackage unicode-data 0.7.0, which updates to Unicode 16.0, in the two tool sets; retain tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies unicode-data >=0.7 with tables matching the chosen GHC. Remove the pin and build both tools followed by `just build`.

### openai: live API test suite

- **Added:** 2026-09-10
- **Root cause:** openai 2.5.4's only test suite reads OPENAI_KEY and performs live API operations, including paid generation and remote resource creation; it cannot run in a reproducible Nix sandbox. The actual build failed on the missing key after successful compilation.
- **Workaround:** Disable only openai's tests in the tool sets; retain adapter and application tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** An upstream release separates offline tests from live integration tests. Enable the offline suite and build both tools followed by `just build`.

### Baikai and Seihou CLI: omitted test fixtures

- **Added:** 2026-09-10
- **Root cause:** Baikai 0.4.1.0 and 0.5.0.0 omit test/fixtures and data/models from their sdists. The catalog-regeneration test also requires data/models. FetchModelsSpec needs models-dev-sample.json; 0.5 additionally needs evidence-request.json, codex-events.jsonl, claude-cli-result.json, and trace-opt-out.jsonl. Seihou CLI 0.8.0.0 omits legacy-manifest-v5.json, read directly or through a helper by six ManifestUpgradeSpec tests.
- **Workaround:** Exclude the catalog-regeneration case, the nine fixture-dependent FetchModels cases, ten additional 0.5 fixture-dependent cases, and the six Seihou manifest cases by Tasty test name. Keep all other tests, including the fixture-independent FetchModels and manifest-upgrade tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** The corresponding Hackage releases include those fixtures and data/models. Remove their skipTests wrappers and build both tools followed by `just build`.

### Baikai Kit: omitted manifest fixtures

- **Added:** 2026-09-10
- **Root cause:** baikai-kit 0.1.0.3 and 0.1.0.4 omit test/fixtures/{mori-kit,rei-kit,seihou-kit}.json; exactly those three compatibility tests failed while the other 26 passed.
- **Workaround:** Exclude those three tests by name and supply Git for the remaining tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** Both selected Hackage releases include the three manifest fixtures. Remove their skipTests wrapper and build both tools followed by `just build`.
