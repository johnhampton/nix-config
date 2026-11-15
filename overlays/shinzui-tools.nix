final: prev:
let
  inherit (prev.haskell.lib) doJailbreak dontCheck dontHaddock justStaticExecutables;
  inherit (prev.haskell.lib.compose) overrideCabal;
  # WORKAROUND(2026-11-15): Hackage omits Seihou fixtures and its schema submodule.
  # Supply assets from the matching release. See docs/nix-workarounds.md.
  seihouSource = prev.fetchFromGitHub {
    owner = "shinzui";
    repo = "seihou";
    rev = "500316a63f53eb865cd373fc7b85aaed8c28049f"; # v0.16.0.0
    hash = "sha256-O1+JAmbDKus0XLKGHKTFFrCjxxV/lIigj4TvAswsVXc=";
  };
  seihouSchema = prev.fetchFromGitHub {
    owner = "shinzui";
    repo = "seihou-schema";
    rev = "82b073b1a737f234f877ae7365fb1045c226477b";
    hash = "sha256-CiNNzh22nU+882HPhHfrxgwcU0tQfBs8YXjn8/uQMcw=";
  };
  # WORKAROUND(2026-11-15): Darwin ps lacks privileged thread state in the sandbox.
  # Match Seihou's release overlay: report unknown state instead of a blank column.
  # Drop with sandbox-compatible upstream process fixtures. See docs/nix-workarounds.md.
  processTools = if prev.stdenv.hostPlatform.isDarwin then
    prev.darwin.ps.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace ps/print.c \
          --replace-fail '*cp = mach_state_table[k->state];' "*cp = k->state == 0 ? '?' : mach_state_table[k->state];"
      '';
    })
  else prev.procps;
  # Both applications now use the same Baikai releases and GHC 9.12.4.
  packages = prev.haskell.packages.ghc9124.override {
    overrides = hfinal: hprev:
      let
        hackage = name: version: sha256:
          dontHaddock (hfinal.callHackageDirect { pkg = name; ver = version; inherit sha256; } { });
        withProcessTools = overrideCabal (drv: {
          postPatch = (drv.postPatch or "") + ''
            for file in $( ${prev.ripgrep}/bin/rg -l '/bin/(ps|sh)' src test --glob '*.hs'); do
              substituteInPlace "$file" \
                --replace-warn /bin/ps ${processTools}/bin/ps \
                --replace-warn /bin/sh ${prev.runtimeShell}
            done
          '';
        });
        withSeihouAssets = name: overrideCabal (drv: {
          prePatch = (drv.prePatch or "") + ''
            cp -r ${seihouSchema} ../schema
            chmod u+w ../schema
            printf '%s\n' '${seihouSchema.rev}' > ../schema/.seihou-pinned-revision
            cp -r ${seihouSource}/${name}/test/fixtures test/fixtures
          '';
          testToolDepends = (drv.testToolDepends or [ ]) ++ [ prev.git prev.python3 prev.gitleaks ];
        });
        withGitTests = overrideCabal (drv: {
          testToolDepends = (drv.testToolDepends or [ ]) ++ [ prev.git ];
        });
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
        # WORKAROUND(2026-09-24): nixpkgs has claude 1.4; Baikai requires 1.5.
        # Its suite makes live API calls. See docs/nix-workarounds.md.
        claude = dontCheck (hackage "claude" "1.5.0" "sha256-Jng3pCOl9d9XqXbHomBJNiXDMViKZYymj9AKTWwHhvY=");
        # WORKAROUND(2026-09-24): Seihou requires effectful-core >=2.7.1.1.
        # WORKAROUND(2026-11-15): Seihou 0.16 also requires effectful >=2.7.1.0.
        # Drop when nixpkgs supplies these versions. See docs/nix-workarounds.md.
        effectful-core = hackage "effectful-core" "2.7.1.2" "sha256-OZhGk0UY3BMWF+oUAQnCvF3hnzscBCm0Cz+nz8p2XM8=";
        strict-mutable-base = hackage "strict-mutable-base" "2.0.0.0" "sha256-3o2PMN8l56X7ULqyNNJrJQZ8xgqqOsxhjm0jfULQt+k=";
        typesafe-hs = hackage "typesafe-hs" "0.1.0.0" "sha256-m+MumjyGAFpahfkhmHBBeThOJGmYWoIjtodK17GWiuY=";
        baikai-effectful = hackage "baikai-effectful" "0.4.0.5" "sha256-Wp2h9jVLu0C9u9huqqrSSPl1EV1O9LKN/jvUoTvBbIU=";
        effectful = hackage "effectful" "2.7.1.0" "sha256-1jr7uWldG/qzNljv41c8ustRFNLnD9DuOFBmL3BYT6g=";
        okf-cli = withGitTests (hackage "okf-cli" "0.13.0.0" "sha256-7J9aMTnX04XR/L9XeEPLUT1aVRgAsIi8nc/jBS9oGmE=");
        okf-core = hackage "okf-core" "0.13.0.0" "sha256-I9JtbHu8sYk3z74k0uYGNyYaNWvKVtKMVh2roMYfFwU=";
        seihou-cli = withSeihouAssets "seihou-cli" (hackage "seihou-cli" "0.16.0.0" "sha256-z9JOWY9cPcS+kYiuqvn+G7JWmMueyUiFxrfGjESE130=");
        seihou-core = withSeihouAssets "seihou-core" (hackage "seihou-core" "0.16.0.0" "sha256-BH6qskQXXdCx9VNmkZ3Nb4FXj6qL69LPnZ46z7N53lU=");
        seihou-okf-extension = withGitTests (hackage "seihou-okf-extension" "0.16.0.0" "sha256-sGfx/CEiI3Vsb4l2HgDCYx+da1sNikk0h46oalIrXXA=");
        # WORKAROUND(2026-09-24): Baikai bounds tls >=2.2; nixpkgs has 2.1.8.
        # Drop when nixpkgs supplies tls >=2.2. See docs/nix-workarounds.md.
        baikai = withProcessTools (doJailbreak (hackage "baikai" "0.10.1.1" "sha256-vPieQ7hrbF046FBI9E8Lo0n2i2P/pHk6Qn8Cv/7RQuc="));
        baikai-claude = withProcessTools (hackage "baikai-claude" "0.7.3.0" "sha256-O82VBJQAy9Jpwp+OgWO54WJ6vRUEPGLuh95ltCsv5r8=");
        baikai-openai = withProcessTools (hackage "baikai-openai" "0.7.3.1" "sha256-45N4RapXHKL29VeIoTn3KkhU8UHGWjb9keto3Tu6RaM=");
        baikai-kit = withGitTests (hackage "baikai-kit" "0.4.0.3" "sha256-xDdV6xGW2vpQrI0NkqlNYrR4QmEM/b75HfySd0ey0l4=");
        baikai-typesafe = hackage "baikai-typesafe" "0.1.0.1" "sha256-B5QfLSylQe5jI2jsZPE0/5Edj78Oe80m0fjzx/A98Vg=";
        shikumi = hackage "shikumi" "0.5.1.0" "sha256-+wQVnmBpWboNgBo9MtKJpPGVxqP9Kpq4lekSXBsC2i8=";
      };
  };
in
{
  okf = justStaticExecutables packages.okf-cli;
  seihou = prev.symlinkJoin {
    name = "seihou-0.16.0.0";
    paths = [
      # WORKAROUND(2026-09-24): Baikai's Paths modules retain library paths
      # and transitively GHC, although only their versions are used at runtime.
      # Includes the TypeSafe adapter in Seihou 0.16. See docs/nix-workarounds.md.
      (overrideCabal (drv: {
        buildTools = (drv.buildTools or [ ]) ++ [ prev.removeReferencesTo ];
        postFixup = (drv.postFixup or "") + ''
          for dep in ${packages.baikai} ${packages.baikai-claude} ${packages.baikai-openai} ${packages.baikai-typesafe}; do
            remove-references-to -t "$dep" $out/bin/seihou
          done
        '';
      }) (justStaticExecutables packages.seihou-cli))
      (justStaticExecutables packages.seihou-okf-extension)
    ];
  };
}
