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

### claude: nixpkgs version too old for Seihou and OKF

- **Added:** 2026-09-24
- **Root cause:** The locked nixpkgs supplies the Haskell claude package 1.4.0; baikai-claude 0.7.3.0 need claude ^>=1.5.
- **Workaround:** Pin Hackage claude 1.5.0 in the shared Seihou and OKF package set. Its only test suite reads ANTHROPIC_KEY and calls the live API, so the pin also disables its tests. Extended to OKF on 2026-10-13.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies claude >=1.5 for the chosen GHC. Remove the `claude` override, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`. If nixpkgs' claude runs the same live suite, keep a `dontCheck` wrapper with its own entry.

### effectful-core: nixpkgs version too old for Seihou

- **Added:** 2026-09-24
- **Root cause:** seihou-core 0.16.0.0 needs effectful-core >=2.7.1.1; the locked nixpkgs supplies 2.6.1.0. effectful-core 2.7 in turn needs strict-mutable-base >=2.0, and nixpkgs supplies 1.1.0.0.
- **Workaround:** Pin Hackage effectful-core 2.7.1.2, strict-mutable-base 2.0.0.0, and effectful 2.7.1.0 in the shared package set. Seihou 0.16.0.0 also requires effectful >=2.7.1.0; extended on 2026-11-15.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies effectful-core >=2.7.1.1 and effectful >=2.7.1.0. Remove the effectful, effectful-core, and strict-mutable-base overrides, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.

### baikai: tls bound excludes nixpkgs' tls

- **Added:** 2026-09-24
- **Root cause:** baikai 0.10.1.1 bounds tls >=2.2 && <2.5; the locked nixpkgs supplies tls 2.1.8. Baikai only matches TLSException constructors, all present in 2.1.8. Pinning tls 2.2+ would also need newer crypton-x509, hpke, and ech-config.
- **Workaround:** Jailbreak baikai in the shared Seihou and OKF package set; TransportClassifySpec checks the constructors at build time. Extended to OKF on 2026-10-13.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies tls >=2.2. Remove the `doJailbreak` wrapper, then run `nix build .#legacyPackages.aarch64-darwin.seihou` followed by `just build`.

### cradle: stale broken marker

- **Added:** 2026-09-10
- **Root cause:** nixpkgs marks cradle 0.0.0.0 broken from a 2024 Hydra failure and refuses evaluation of the Baikai dependency. Its test harness also requires PYTHON_BIN_PATH, which the stock derivation does not set.
- **Workaround:** Clear that package's marker only inside the tools' GHC 9.12.4 sets; set PYTHON_BIN_PATH to the Nix Python interpreter and retain its tests to validate compatibility.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs no longer marks cradle broken and supplies the required test environment. Remove the cradle override and build both tools followed by `just build`.

### unicode-data: Unicode tables differ from GHC 9.12

- **Added:** 2026-09-10
- **Root cause:** unicode-data 0.6.0's Unicode 15.1 case-conversion tests fail against GHC 9.12's Unicode 16.0 tables (toUpper/toTitle on U+019B).
- **Workaround:** Pin Hackage unicode-data 0.7.0, which updates to Unicode 16.0, in the shared package set; retain tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** nixpkgs supplies unicode-data >=0.7 with tables matching the chosen GHC. Remove the pin and build both tools followed by `just build`.

### openai: live API test suite

- **Added:** 2026-09-10
- **Root cause:** openai 2.5.4's only test suite reads OPENAI_KEY and performs live API operations, including paid generation and remote resource creation; it cannot run in a reproducible Nix sandbox. The actual build failed on the missing key after successful compilation.
- **Workaround:** Disable only openai's tests in the shared package set; retain adapter and application tests.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** An upstream release separates offline tests from live integration tests. Enable the offline suite and build both tools followed by `just build`.

### Seihou: Hackage archives omit test fixtures and schema

- **Added:** 2026-11-15
- **Root cause:** Seihou core and CLI 0.16.0.0 omit test/fixtures and the schema submodule from their Hackage archives. Their tests import those files from the package and its parent directory.
- **Workaround:** Supply test fixtures from the exact v0.16.0.0 Git commit and schema from its recorded submodule revision; include Git, Python, and Gitleaks for integration tests. This replaces the older disabled core suite and fixture exclusions.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** Both Hackage archives contain their fixtures and provide the schema at the paths the tests use. Remove `withSeihouAssets`, `seihouSource`, and `seihouSchema`, then build both tools followed by `just build`.

### Baikai: hardcoded process tools in the Darwin sandbox

- **Added:** 2026-11-15
- **Root cause:** Baikai 0.10.1.1 and the 0.7.3 adapters use /bin/ps and /bin/sh in runtime process handling and test fixtures. System ps cannot inspect processes in the Nix Darwin sandbox; packaged Darwin ps emits a blank state when privileged thread state is unavailable.
- **Workaround:** Use Nix's shell and packaged ps, applying Seihou v0.16.0.0's ps patch to emit an unknown state. Apply the paths to the runtime handler and test fixtures. This replaces process-related test exclusions.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** Baikai and adapters use declared process tools and sandbox-compatible fixtures. Remove `withProcessTools` and `processTools`, build both tools with their tests, then run `just build`.

### Baikai: Paths modules leak GHC into Seihou

- **Added:** 2026-09-24
- **Root cause:** Baikai 0.10.1.1, Baikai Claude 0.7.3.0, Baikai OpenAI 0.7.3.1, and Baikai TypeSafe 0.1.0.1 import their generated Paths modules for version strings. Those modules retain library installation paths, which transitively reference GHC. Seihou 0.16.0.0 passes all 1,009 CLI tests but fails justStaticExecutables' disallowGhcReference check without this fix.
- **Workaround:** Remove references to those four library paths from bin/seihou after fixup. Only their version values are used at runtime; the installation directories are unused. Extended to the TypeSafe adapter on 2026-11-15.
- **Files:** overlays/shinzui-tools.nix, wired in flake.nix.
- **Remove when:** Baikai packages no longer retain these Paths directories, or nixpkgs strips them. Remove the overrideCabal wrapper around seihou-cli, then build Seihou followed by `just build`.
