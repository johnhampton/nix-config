final: prev:
let
  inherit (prev.haskell.lib) dontCheck dontHaddock justStaticExecutables;
  inherit (prev.haskell.lib.compose) overrideCabal;
  # Keep the application compiler separate from the interactive Haskell environment.
  base = prev.haskell.packages.ghc9124;
  shared = hfinal: hprev:
    let
      hackage = name: version: sha256:
        dontHaddock (hfinal.callHackageDirect { pkg = name; ver = version; inherit sha256; } { });
    in
    {
      # WORKAROUND(2026-09-10): 0.6 tests compare Unicode 15.1 with GHC's 16.0.
      # Drop once nixpkgs ships >=0.7 with matching tables. See docs/nix-workarounds.md.
      unicode-data = hackage "unicode-data" "0.7.0" "sha256-2Mp3jhxyEa54Y/V22cKkFexdqUARHiHVOSNscBmBXEE=";
      streamly = hackage "streamly" "0.11.1" "sha256-4h1MwaN7eXMvzXKyjggIjjR3BlsGzl4vfCO7VBGGvrc=";
      streamly-core = hackage "streamly-core" "0.3.1" "sha256-k9h+I74GNsluf55hJFDZiLwEO2x9moFvtCarCeCpaa4=";
      # Revision 1 permits QuickCheck 2.16; apply before cabal2nix and compilation.
      optparse-applicative = dontHaddock (hfinal.callCabal2nix "optparse-applicative"
        (prev.runCommand "optparse-applicative-0.19.0.0-revised" {
          src = prev.fetchzip {
            url = "https://hackage.haskell.org/package/optparse-applicative-0.19.0.0/optparse-applicative-0.19.0.0.tar.gz";
            hash = "sha256-dhqvRILfdbpYPMxC+WpAyO0KUfq2nLopGk1NdSN2SDM=";
          };
          cabalFile = prev.fetchurl {
            url = "https://hackage.haskell.org/package/optparse-applicative-0.19.0.0/revision/1.cabal";
            hash = "sha256-TB3L2/JJj3zdiIJuh2QD23+NgZMZYgYOxMOlehhsbMM=";
          };
        } ''
          cp -r $src $out
          chmod -R u+w $out
          cp $cabalFile $out/optparse-applicative.cabal
        '') { });
      # WORKAROUND(2026-09-10): stale broken marker and missing Python test env.
      # Drop once nixpkgs marks cradle working. See docs/nix-workarounds.md.
      cradle = prev.haskell.lib.markUnbroken (overrideCabal (drv: {
        preCheck = (drv.preCheck or "") + ''
          export PYTHON_BIN_PATH=${prev.python3}/bin/python3
        '';
      }) hprev.cradle);
      generic-lens = hackage "generic-lens" "2.3.0.0" "sha256-V8M8gkbrrLAsJ42IKa26HnU28sfljwUZuBiCJBV8ABs=";
      generic-lens-core = hackage "generic-lens-core" "2.3.0.0" "sha256-Abntgf3UMhQed5gOc6sDoVilMc0FRRCh8VJCeoQfNRY=";
      # WORKAROUND(2026-09-10): the suite requires a key and makes live API calls.
      # Drop once upstream provides offline tests. See docs/nix-workarounds.md.
      openai = dontCheck (hackage "openai" "2.5.4" "sha256-DN++TyDWVP3AU8QGzan+g4eTIioYZGjGLFuvi1Z4mZA=");
    };
  tools = versions: base.override {
    overrides = prev.lib.composeExtensions shared (hfinal: hprev:
      let
        hackage = name: version: sha256:
          dontHaddock (hfinal.callHackageDirect { pkg = name; ver = version; inherit sha256; } { });
        skipTests = names: overrideCabal (drv: {
          testFlags = (drv.testFlags or [ ]) ++ [
            "--pattern"
            (prev.lib.concatMapStringsSep " && " (name: "!/" + name + "/") names)
          ];
        });
        withGitTests = overrideCabal (drv: {
          testToolDepends = (drv.testToolDepends or [ ]) ++ [ prev.git ];
        });
      in
      {
        # WORKAROUND(2026-09-10): sdists omit fixtures used by these tests.
        # Retain the rest of both suites. See docs/nix-workarounds.md.
        baikai = skipTests [
          "regenerating from data"
          "OpenAI normalization filters, curates, and maps fields"
          "tool_call: false model is excluded"
          "Responses-API-only id is excluded by curation"
          "pdf modality is dropped"
          "missing cache costs default to 0.0 in rendered output"
          "whole-number costs render with a trailing .0"
          "Anthropic curation keeps exactly the one fixture model"
          "suffix is stripped from display names"
          "override corrects a deliberately-wrong upstream cache price"
          # These fixture-based tests were added in Baikai 0.5.
          "a recorded run yields its text, thread id, and token counts"
          "a recorded run reports no model, rather than the requested one"
          "a recorded run yields its text, session id, model, usage, and cost"
          "a digest is sha256: plus 64 lowercase hex characters"
          "the request commitment matches the golden value"
          "the configuration digest matches the golden value"
          "the configuration projection drops all content"
          "the projection keeps the configuration it is supposed to"
          "the commitment digest does see the content"
          "an opted-out call's trace bytes match the golden fixture"
        ] (hackage "baikai" versions.baikai.version versions.baikai.hash);
        baikai-claude = hackage "baikai-claude" versions.baikai-claude.version versions.baikai-claude.hash;
        baikai-openai = hackage "baikai-openai" versions.baikai-openai.version versions.baikai-openai.hash;
        # WORKAROUND(2026-09-10): the kit sdists omit three manifest fixtures.
        # Drop when the fixtures ship. See docs/nix-workarounds.md.
        baikai-kit = skipTests [
          "mori-kit.json decodes"
          "rei-kit.json decodes"
          "seihou-kit.json decodes"
        ] (withGitTests (hackage "baikai-kit" versions.baikai-kit.version versions.baikai-kit.hash));
        okf-core = hackage "okf-core" versions.okf-core.version versions.okf-core.hash;
        okf-cli = withGitTests (hackage "okf-cli" "0.9.0.0" "sha256-rX2/8F7XbazrwJ9myQBUXWYBolECPU6VRevIN4a30p0=");
        # WORKAROUND(2026-09-10): these tests read an omitted JSON fixture.
        # Drop once the sdist includes it. See docs/nix-workarounds.md.
        seihou-cli = skipTests [
          "finds every legacy reference in a schema-5 manifest, in document order"
          "replaces every recorded path with its origin and bumps the schema version"
          "leaves no machine-specific path anywhere in the document"
          "preserves every field it does not convert"
          "produces a document the ordinary manifest decoder accepts"
          "reports each artifact once even though it appears in three records"
        ] (withGitTests (hackage "seihou-cli" "0.8.0.0" "sha256-MoZesrs5T3Ib01GkqVxA+MOp+6ZED9ATX0LAIZES4nA="));
        seihou-okf-extension = withGitTests (hackage "seihou-okf-extension" "0.8.0.0" "sha256-6BLAduWZ9kYebUMrEwogEmVvsr0zv8gBr4FPW0zyZ60=");
        # WORKAROUND(2026-09-10): the sdist omits test/fixtures and schema.
        # Drop dontCheck once the release includes both. See docs/nix-workarounds.md.
        seihou-core = dontCheck (hackage "seihou-core" "0.8.0.0" "sha256-nJg60IyzCnif4Nsy9lck+DWhAaVHc2QDUg6oEv1nUqQ=");
      });
  };
  # The releases require different Baikai and okf-core APIs; keep their bounds.
  okfPackages = tools {
    okf-core = { version = "0.9.0.0"; hash = "sha256-a34kTE5G3o+6Q+Kv/TVRpbGVzfTiaoPvKxsMZmeqYcE="; };
    baikai = { version = "0.5.0.0"; hash = "sha256-JSTgBTgChhomZytfXPd0zOI8fs6vGHFCaiCehqSEW/4="; };
    baikai-claude = { version = "0.5.0.0"; hash = "sha256-LifIO9TeTFw/RbN2+QGozbpiexEyC0boym3c4YdXldU="; };
    baikai-openai = { version = "0.5.0.0"; hash = "sha256-PTEUvqU8NPWq2jDzGxrb26Y1j948JpC00UgtjnwP9Ys="; };
    baikai-kit = { version = "0.1.0.4"; hash = "sha256-4SDR2DXZIbGCv+jJY5uU77xS1v8jdHssV1Htg0JWVro="; };
  };
  seihouPackages = tools {
    okf-core = { version = "0.8.0.0"; hash = "sha256-ADugvEouY5r+o1W0K09M7IX0GTVuZ1OXvA+Vem/QnBI="; };
    baikai = { version = "0.4.1.0"; hash = "sha256-OXuxc3ZUz2WoHSR2J4NHKhfojdEpF4UffWVPltl9Cu0="; };
    baikai-claude = { version = "0.4.0.1"; hash = "sha256-EMcDesp6RPxmQ81NVwPnMVzvG7VqB8cOd12Eli404Es="; };
    baikai-openai = { version = "0.4.0.0"; hash = "sha256-nrujXC2D5eE6cxCRUQDXDoLW2q1epdrLUOdfdnerC/4="; };
    baikai-kit = { version = "0.1.0.3"; hash = "sha256-6Nu22t0NQho2GQ+xlgdUsHODNKALUFlqdXnxXTZjqFg="; };
  };
in
{
  okf = justStaticExecutables okfPackages.okf-cli;
  seihou = prev.symlinkJoin {
    name = "seihou-0.8.0.0";
    paths = [
      (justStaticExecutables seihouPackages.seihou-cli)
      (justStaticExecutables seihouPackages.seihou-okf-extension)
    ];
  };
}
