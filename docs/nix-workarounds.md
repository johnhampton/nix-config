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

### Worktrunk: pinned nixpkgs predates required version

- **Added:** 2026-09-24
- **Root cause:** The locked nixpkgs supplies Worktrunk 0.74.0, below the required 0.79.0 release.
- **Workaround:** Override Worktrunk's source and Cargo dependency hashes to build 0.79.0, retaining nixpkgs packaging and checks.
- **Files:** overlays/worktrunk.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies Worktrunk >=0.79.0. Remove the overlay and its import, run `just build`, and confirm `nix eval --raw .#legacyPackages.aarch64-darwin.worktrunk.version` reports >=0.79.0.

### seihou-core: missing Hackage test assets

- **Added:** 2026-09-10
- **Root cause:** seihou-core 0.8.0.0, 0.9.0.0, and 0.10.1.0 omit test/fixtures and schema from their Hackage archives; ScaffoldSpec loads schema/package.dhall and other suites load fixtures.
- **Workaround:** Disable only seihou-core tests; keep other package tests and verify the installed CLIs separately.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** A Hackage release includes both test/fixtures and schema/package.dhall. Remove its dontCheck wrapper and run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.


### claude: nixpkgs version too old for Seihou and OKF

- **Added:** 2026-09-24
- **Root cause:** The locked nixpkgs supplies the Haskell claude package 1.4.0; baikai-claude 0.7.1.0 and 0.7.1.1 need claude ^>=1.5.
- **Workaround:** Pin Hackage claude 1.5.0 in the Seihou and OKF tool sets. Its only test suite reads ANTHROPIC_KEY and calls the live API, so the pin also disables its tests. Extended to OKF on 2026-10-13.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies claude >=1.5 for the chosen GHC. Remove the `claude` entries from both tool sets and their override, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`. If nixpkgs' claude runs the same live suite, keep a `dontCheck` wrapper with its own entry.

### effectful-core: nixpkgs version too old for Seihou

- **Added:** 2026-09-24
- **Root cause:** seihou-core 0.10.1.0 needs effectful-core >=2.7.1.1; the locked nixpkgs supplies 2.6.1.0. effectful-core 2.7 in turn needs strict-mutable-base >=2.0, and nixpkgs supplies 1.1.0.0.
- **Workaround:** Pin Hackage effectful-core 2.7.1.2 and strict-mutable-base 2.0.0.0 through `pins` in the Seihou tool set only.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies effectful-core >=2.7.1.1. Remove `pins` from `seihouPackages`, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.

### baikai: tls bound excludes nixpkgs' tls

- **Added:** 2026-09-24
- **Root cause:** baikai 0.7.2.0 and 0.8.0.0 bound tls >=2.2 && <2.5; the locked nixpkgs supplies tls 2.1.8. Baikai only matches TLSException constructors, all present in 2.1.8. Pinning tls 2.2+ would also need newer crypton-x509, hpke, and ech-config.
- **Workaround:** Jailbreak baikai in the Seihou and OKF tool sets (`jailbreak = true` on their version entries); TransportClassifySpec checks the constructors at build time. Extended to OKF on 2026-10-13.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies tls >=2.2. Remove both `jailbreak = true` entries, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.

### Baikai: Paths modules leak GHC into Seihou

- **Added:** 2026-09-24
- **Root cause:** baikai 0.8.0.0, baikai-claude 0.7.1.1, and baikai-openai 0.7.1.1 import their Paths_ modules for their versions. The linked modules keep each package's install directories as strings in the static `seihou` binary, and those library outputs reference GHC, so justStaticExecutables' disallowGhcReference check fails.
- **Workaround:** Run `remove-references-to` on `bin/seihou` for the three Baikai store paths after fixup. Only `version` is read at runtime; the directory strings are unused.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** The Baikai packages no longer use their Paths_ modules, or nixpkgs strips such references itself. Remove the overrideCabal wrapper around seihou-cli, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.

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
- **Root cause:** Baikai 0.7.2.0 omits test/fixtures and data/models from its sdist. The catalog-regeneration test also requires data/models. FetchModelsSpec needs models-dev-sample.json, evidence-request.json, codex-events.jsonl, claude-cli-result.json, and trace-opt-out.jsonl. Seihou CLI 0.10.1.0 omits legacy-manifest-v5.json, read by nine manifest and migration cases, and the `schema` directory, read by eleven checkout sync cases. Baikai 0.8.0.0 now includes its fixtures and model data.
- **Workaround:** Exclude the fixture-dependent Baikai cases only in the OKF package set, the nine Seihou manifest cases, and the checkout sync group. Keep all other tests, including the full Baikai suite in the Seihou package set. Extended to OKF on 2026-10-13; narrowed for Seihou on 2026-10-19.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** The corresponding Hackage releases include those fixtures and data/models. Remove their skipTests wrappers and build both tools followed by `just build`.

### Baikai: subprocess tests cannot inspect processes in the Darwin sandbox

- **Added:** 2026-10-19
- **Root cause:** Baikai 0.8.0.0's `CliProcessSpec` calls macOS `/bin/ps` to inspect child processes, which Nix's Darwin sandbox denies. Its executable-identity fixture also runs a `/bin/sh` script that cannot return a version in that sandbox. Baikai Claude and Baikai OpenAI 0.7.1.1 have CLI fixtures with the same process dependency. Twelve of 812 Baikai tests and 14 of 430 Baikai Claude tests fail for these reasons.
- **Workaround:** Exclude the `CliProcessSpec` group and the single executable-identity case from Baikai; exclude the affected CLI fixture groups and stderr flood cases from both adapters in the Seihou package set. Run the other tests, including the formerly skipped fixture tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** Baikai and both adapters supply sandbox-compatible subprocess fixtures or the Nix Darwin sandbox permits those process observations. Remove `sandboxTests` and build Seihou followed by `just build`.

### Baikai: environment-mutating tests race in parallel

- **Added:** 2026-10-19
- **Root cause:** Baikai 0.8.0.0 tests set and unset `OPENAI_API_KEY` around individual cases while Tasty runs cases in parallel. The default OpenAI key resolution case intermittently sees an empty value.
- **Workaround:** Pass `--num-threads=1` to the Baikai test suite in the Seihou package set, retaining every selected case.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** Upstream serializes environment-mutating cases or isolates their environments. Remove `extraTestFlags` and run the Seihou build repeatedly before `just build`.

### Seihou CLI: agent subprocess tests cannot inspect processes in the Darwin sandbox

- **Added:** 2026-10-19
- **Root cause:** Nine Seihou CLI agent integration cases launch fake providers through Baikai's owned process handler, which calls macOS `/bin/ps`. Nix's Darwin sandbox denies that process observation, so the cases fail before their assertions.
- **Workaround:** Exclude those nine cases by Tasty test name in the Seihou CLI package set; keep the other CLI tests enabled.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** The provider process handler and fixtures can run inside Nix's Darwin sandbox. Remove the nine exclusions and build Seihou followed by `just build`.
