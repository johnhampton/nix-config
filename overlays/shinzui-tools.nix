final: prev:
let
  inherit (prev.haskell.lib) doJailbreak dontCheck dontHaddock justStaticExecutables;
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
        # WORKAROUND(2026-09-10): older sdists omit fixtures used by these tests.
        # Baikai 0.8 includes them. See docs/nix-workarounds.md.
        baikai = overrideCabal (drv: {
          testFlags = (drv.testFlags or [ ]) ++ (versions.baikai.extraTestFlags or [ ]);
        }) ((if versions.baikai.fixturesIncluded or false then
          skipTests (versions.baikai.sandboxTests or [ ])
        else
          skipTests ([
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
          ] ++ versions.baikai.skipTests or [ ])) ((if versions.baikai.jailbreak or false then doJailbreak else (x: x))
          (hackage "baikai" versions.baikai.version versions.baikai.hash)));
        baikai-claude = (if versions.baikai-claude ? sandboxTests
          then skipTests versions.baikai-claude.sandboxTests
          else (x: x)) (hackage "baikai-claude" versions.baikai-claude.version versions.baikai-claude.hash);
        baikai-openai = (if versions.baikai-openai ? sandboxTests
          then skipTests versions.baikai-openai.sandboxTests
          else (x: x)) (hackage "baikai-openai" versions.baikai-openai.version versions.baikai-openai.hash);
        baikai-kit = withGitTests (hackage "baikai-kit" versions.baikai-kit.version versions.baikai-kit.hash);
        okf-core = hackage "okf-core" versions.okf-core.version versions.okf-core.hash;
        # WORKAROUND(2026-09-24): nixpkgs ships claude 1.4.0; baikai-claude 0.7 needs ^>=1.5.
        # Its suite needs ANTHROPIC_KEY and calls the live API, so skip it.
        # Drop once nixpkgs ships claude >=1.5. See docs/nix-workarounds.md.
        claude = if versions ? claude
          then dontCheck (hackage "claude" versions.claude.version versions.claude.hash)
          else hprev.claude;
        okf-cli = withGitTests (hackage "okf-cli" "0.10.0.0" "sha256-sAIGsGCcRiZSG2PjfaikApdxbjPS6DqijItIQ6FZZGc=");
        # WORKAROUND(2026-09-10): these tests read an omitted JSON fixture.
        # WORKAROUND(2026-10-19): CLI agent fixtures need /bin/ps, and sync
        # fixtures need the omitted schema directory. See docs/nix-workarounds.md.
        seihou-cli = skipTests [
          "finds every legacy reference in a schema-5 manifest, in document order"
          "replaces every recorded path with its origin and stamps schema 6"
          "leaves no machine-specific path anywhere in the document"
          "preserves every field it does not convert"
          "produces a document the ordinary manifest decoder accepts"
          "reports each artifact once even though it appears in three records"
          "blocks a schema-5 conversion it cannot verify before any later step runs"
          "chains 5 through the current schema in order on a dry run and writes nothing"
          "stops a schema-5 conversion at --to 6"
          "manifest-only checkout sync"
          "enables Seihou's tool-only Codex skills in interactive and batch launches"
          "automatically uses the batch CLI provider when stdin is not a terminal"
          "applies a blueprint-declared model and effort to the launched agent"
          "lets a --model flag override the blueprint declaration"
          "proceeds under --allow-downgrade and prints what it overrode"
          "creates no trace file when tracing is not configured"
          "writes a correlated start"
          "lets --trace off override a configured file trace"
          "sends --trace stderr to stderr, leaving stdout clean"
        ] (withGitTests (hackage "seihou-cli" "0.10.1.0" "sha256-fy8G6pOtRHV2Y4r9Cks4TQxOByofDHxf/Ud3ZGfoP2k="));
        seihou-okf-extension = withGitTests (hackage "seihou-okf-extension" "0.10.1.0" "sha256-WZgJ2EkjVEWUYy8kLSs94IWIor7Vz+HFSDb/ZgaxpbI=");
        # WORKAROUND(2026-09-10): the sdist omits test/fixtures and schema.
        # Drop dontCheck once the release includes both. See docs/nix-workarounds.md.
        seihou-core = dontCheck (hackage "seihou-core" "0.10.1.0" "sha256-GIZ4LpUUgRUQ9Sn1k3hpVYEFvImIM+FRx20AaX2fwk4=");
      } // prev.lib.mapAttrs (name: v: hackage name v.version v.hash) (versions.pins or { }));
  };
  # OKF and Seihou require different Baikai releases; keep their bounds separate.
  okfPackages = tools {
    okf-core = { version = "0.10.0.0"; hash = "sha256-SnxlWd8d4MJrcIXv+tMF6xqUzi6L3POcbGg8BbLbd4M="; };
    # WORKAROUND(2026-10-13): Baikai 0.7.2 bounds tls >=2.2; nixpkgs has 2.1.8.
    # Drop once nixpkgs ships tls >=2.2. See docs/nix-workarounds.md.
    baikai = {
      version = "0.7.2.0";
      hash = "sha256-YF6BEQvWqegthAJSjNa+yOSpexuENpSzFZehN/+2DjQ=";
      jailbreak = true;
      # WORKAROUND(2026-10-13): the Hackage sdist omits models-dev-sample.json.
      # Drop these exclusions when the fixture ships. See docs/nix-workarounds.md.
      skipTests = [
        "per-model API and Responses compat survive normalization and rendering"
        "refresh preserves Astra endpoint restrictions despite upstream tool support"
        "fast rates and capability survive fetch and generator on curated models"
        "curated pricing survives fetch rendering and generator parsing"
        "Anthropic normalization carries the curated generation facts"
        "the generation facts render as a per-model compat block"
        "an OpenAI model renders no compat block"
      ];
    };
    baikai-claude = { version = "0.7.1.0"; hash = "sha256-HskzJuUC3ZTYcQQcTLbV/IJ030fvCm5oDEEddNdH46M="; };
    baikai-openai = { version = "0.7.1.0"; hash = "sha256-2d/u91NmFK+Na+/3T2JxfsgbYGTH5GZXa4oXDL4eslM="; };
    baikai-kit = { version = "0.4.0.0"; hash = "sha256-k3Njva+Rb/K8G1fzN7UXUsNvTu/T7UoWEYyxnJh50fw="; };
    # WORKAROUND(2026-10-13): nixpkgs has claude 1.4; Baikai Claude 0.7.1 needs >=1.5.
    # Drop once nixpkgs ships claude >=1.5. See docs/nix-workarounds.md.
    claude = { version = "1.5.0"; hash = "sha256-Jng3pCOl9d9XqXbHomBJNiXDMViKZYymj9AKTWwHhvY="; };
  };
  seihouPackages = tools {
    okf-core = { version = "0.10.0.0"; hash = "sha256-SnxlWd8d4MJrcIXv+tMF6xqUzi6L3POcbGg8BbLbd4M="; };
    # WORKAROUND(2026-09-24): baikai 0.8 bounds tls >=2.2 but compiles against nixpkgs' 2.1.8.
    # Drop jailbreak once nixpkgs ships tls >=2.2. See docs/nix-workarounds.md.
    baikai = {
      version = "0.8.0.0";
      hash = "sha256-9taJUqln85cHFlEu4GMDf1PmKn8VnGvrCnjBOYiNuvo=";
      jailbreak = true;
      fixturesIncluded = true;
      # WORKAROUND(2026-10-19): these subprocess tests call /bin/ps or /bin/sh,
      # which Nix's Darwin sandbox denies. See docs/nix-workarounds.md.
      sandboxTests = [
        "CliProcessSpec: shared owned process scopes"
        "a resolvable tool reports its path and its --version line"
      ];
      # WORKAROUND(2026-10-19): tests that set OPENAI_API_KEY race in parallel.
      # Keep every selected test, but run them serially. See docs/nix-workarounds.md.
      extraTestFlags = [ "--num-threads=1" ];
    };
    baikai-claude = {
      version = "0.7.1.1";
      hash = "sha256-ZKqRqMd67GmhbpNts4/qbE0pPy3kdy6Z5pKy0JQC3fw=";
      # WORKAROUND(2026-10-19): CLI fixtures call /bin/ps inside Nix's sandbox.
      # Keep the API and pure tests. See docs/nix-workarounds.md.
      sandboxTests = [
        "claude batch provider survives a 1MiB stderr flood without deadlock"
        "CliCancellationSpec: Claude owned batch cancellation"
        "CliEvidenceSpec: Claude CLI model-call evidence"
        "fake claude process"
      ];
    };
    baikai-openai = {
      version = "0.7.1.1";
      hash = "sha256-GVh0bpTJRqwdzqWIHpSqVjESa9wCJ9ZXavklv44i22s=";
      # WORKAROUND(2026-10-19): CLI fixtures call /bin/ps inside Nix's sandbox.
      # Keep the API and pure tests. See docs/nix-workarounds.md.
      sandboxTests = [
        "codex batch provider survives a 1MiB stderr flood without deadlock"
        "CliCancellationSpec: Codex owned batch cancellation"
        "CliEvidenceSpec: Codex CLI model-call evidence"
        "fake codex process"
      ];
    };
    baikai-kit = { version = "0.4.0.1"; hash = "sha256-BE9N/zS/JpmTp7sr4Rg8SjW0wdWg7K2Bpq0jSPDl7gw="; };
    claude = { version = "1.5.0"; hash = "sha256-Jng3pCOl9d9XqXbHomBJNiXDMViKZYymj9AKTWwHhvY="; };
    # WORKAROUND(2026-09-24): seihou-core 0.10.1 needs effectful-core >=2.7.1.1; nixpkgs has 2.6.1.0.
    # Drop once nixpkgs ships effectful-core >=2.7.1.1. See docs/nix-workarounds.md.
    pins = {
      effectful-core = { version = "2.7.1.2"; hash = "sha256-OZhGk0UY3BMWF+oUAQnCvF3hnzscBCm0Cz+nz8p2XM8="; };
      strict-mutable-base = { version = "2.0.0.0"; hash = "sha256-3o2PMN8l56X7ULqyNNJrJQZ8xgqqOsxhjm0jfULQt+k="; };
    };
  };
in
{
  okf = justStaticExecutables okfPackages.okf-cli;
  seihou = prev.symlinkJoin {
    name = "seihou-0.10.1.0";
    paths = [
      # WORKAROUND(2026-09-24): Baikai packages read Paths_*.version, which links
      # their store paths into the binary and, through them, GHC.
      # Drop once they stop using Paths_. See docs/nix-workarounds.md.
      (overrideCabal (drv: {
        buildTools = (drv.buildTools or [ ]) ++ [ prev.removeReferencesTo ];
        postFixup = (drv.postFixup or "") + ''
          for dep in ${seihouPackages.baikai} ${seihouPackages.baikai-claude} ${seihouPackages.baikai-openai}; do
            remove-references-to -t "$dep" $out/bin/seihou
          done
        '';
      }) (justStaticExecutables seihouPackages.seihou-cli))
      (justStaticExecutables seihouPackages.seihou-okf-extension)
    ];
  };
}
