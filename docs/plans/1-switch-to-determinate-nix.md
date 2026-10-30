---
id: 1
slug: switch-to-determinate-nix
title: "Switch to Determinate Nix"
kind: exec-plan
created_at: 2026-10-30T01:13:20Z
provenance:
  created_by:
    model: "claude-opus-5-5"
    harness: "claude-code"
    at: 2026-10-30T01:13:20Z
  reviews:
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-30T01:33:19Z
      verdict: "changes-requested"
      note: "Activation deletes the reused builder VM; keychain preflight trusts a missing executable; x86 emulation is absent; store preservation and cache authentication need stronger acceptance checks."
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-30T01:53:12Z
      verdict: "changes-requested"
      note: "Prior findings addressed; disable automatic GC before first daemon start, make keychain replacement fail closed, and document recovery through a macOS shell outside /nix; clarify FlakeHub token login."
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-30T02:16:09Z
      verdict: "changes-requested"
      note: "Prior blockers addressed; keep the GC-disabled config present throughout activation and make the first-switch recovery handler propagate failure and halt cleanup."
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-30T02:39:20Z
      verdict: "changes-requested"
      note: "Prior activation findings addressed; evaluated Determinate module includes builder defaults, so switch.sh exact seed comparison rejects successful activation and prevents retries. Validate GC semantically and accept managed config on retry."
    - model: "gpt-6-astra"
      harness: "codex-cli"
      at: 2026-10-30T02:45:05Z
      verdict: "approved"
      note: "All prior findings addressed; verified generated module JSON, seed hash, script syntax, and isolated first-run, retry, build-failure, activation-recovery, and unsafe-GC rejection paths. No blocking findings."
  revisions:
    - model: "claude-opus-5-5"
      harness: "claude-code"
      at: 2026-10-30T01:39:37Z
      mode: "update"
      note: "Native Linux Builder replaces VM, aarch64-linux only; two-pass keychain; stronger store/cache/token acceptance"
---

# Switch to Determinate Nix

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries,
Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.
If durable project context changes, update or create ADRs in docs/adr/ in the same change.
Record friction met while implementing in the friction-log bundle as it occurs (see FRICTION.md).


## Purpose / Big Picture

John's MacBook Pro (nix-darwin configuration `Johns-MacBook-Pro`) runs upstream Nix ("upstream" means the stock Nix from the NixOS project, here version 2.34.9). That Nix is installed, configured, and run by nix-darwin. This plan replaces it with Determinate Nix, a Nix distribution from Determinate Systems. Determinate Nix adds a background service called `determinate-nixd` that manages the Nix daemon, upgrades, optional automatic garbage collection, and a built-in Linux builder. When the plan is done, `nix --version` reports `nix (Determinate Nix 3.x.y) 2.x.y` and `sudo darwin-rebuild switch` still activates the whole system. The things John relies on keep working: flakes, the private `tan.cachix.org` binary cache, the agenix-provided GitHub access token, and building `aarch64-linux` derivations locally. Local Linux builds now go through Determinate's built-in builder instead of nix-darwin's VM.

The existing `/nix` store must survive the switch. Losing the store would mean downloading or rebuilding everything, and John has explicitly rejected that. Determinate's installer can install over an existing upstream install without deleting the store (see Context and Orientation), and this plan relies on that.


## Progress

- [ ] Milestone 1: the flake builds `Johns-MacBook-Pro` with the Determinate module. The built system contains `etc/nix/nix.custom.conf` and no nix-darwin-managed `etc/nix/nix.conf`, and no Linux builder VM is configured. Nothing is activated.
- [ ] Milestone 2: Determinate Nix is installed over the existing install. `/nix/var/nix/profiles/default/bin/nix --version` reports Determinate Nix, and every store path recorded before the install is still valid.
- [ ] Milestone 3: `sudo darwin-rebuild switch` activates the Milestone 1 configuration on Determinate Nix. Custom settings, the built-in Linux builder, the private TAN cache, and the GitHub access token all work, and still work after a reboot. The old UUID-named keychain item is then deleted, and `/nix` still mounts on a further reboot with only the Determinate-named item.


## Surprises & Discoveries

- Observation: The existing volume's encryption password is not stored the way the Determinate installer looks for it, so the installer will abort at planning on this machine unless a second keychain item is added. The upstream install unlocks `/nix` at boot through `/Library/LaunchDaemons/org.nixos.darwin-store.plist`, which reads the password from a keychain item whose service is the volume UUID. The Determinate installer only looks for service `Nix Store`, account `Nix Store`, label `disk3 encryption password`. No item with service `Nix Store` exists. It can create that item itself only for a volume it creates.
  Evidence:

    ```text
    $ security find-generic-password -s "Nix Store" /Library/Keychains/System.keychain
    security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain.
    $ plutil -p /Library/LaunchDaemons/org.nixos.darwin-store.plist   (ProgramArguments, abridged)
    /usr/bin/security find-generic-password -s '1F62D489-B73B-4A98-A5E1-978E440B8A1B' -w | /usr/sbin/diskutil apfs unlockVolume '1F62D489-B73B-4A98-A5E1-978E440B8A1B' -mountpoint '/nix' -stdinpassphrase
    $ diskutil info /nix   (abridged)
    Device Identifier: disk3s7   Volume UUID: 1F62D489-B73B-4A98-A5E1-978E440B8A1B   Part of Whole: disk3   FileVault: Yes
    ```

- Observation: Until Milestone 3, plain `nix` resolves to nix-darwin's copy at `/run/current-system/sw/bin/nix`, so `nix --version` keeps reporting upstream Nix right after the Determinate install. Milestone 2 checks the default profile's `nix` instead. `/nix/var/nix/profiles/default/Library/LaunchDaemons/` does not exist before the install.
  Evidence:

    ```text
    $ which nix
    /run/current-system/sw/bin/nix
    ```

- Observation: The review on 2026-10-30 found a problem with the first version of this plan. It reused the old VM, and nix-darwin's activation deletes `/var/lib/linux-builder` whenever its `nix.linux-builder` is turned off, so the VM it tried to keep would have been wiped. The reviewer also found that the VM guest is `aarch64-linux` with no x86 emulation, so listing `x86_64-linux` never actually enabled x86 builds. Both findings led to the builder decision below. The deletion is now the intended cleanup.

- Observation: `tan.cachix.org` is private. A request without credentials gets HTTP 401, and authenticated access works through the per-user `netrc-file`. `github:topagentnetwork/hchart` is a private repository, so fetching it proves the agenix GitHub access token is in use. hchart's own output is not in the TAN cache, so it cannot double as the cache check.
  Evidence:

    ```text
    $ curl -s -o /dev/null -w '%{http_code}\n' https://tan.cachix.org/nix-cache-info
    401
    $ gh repo view topagentnetwork/hchart --json visibility -q .visibility
    PRIVATE
    ```


## Decision Log

- Decision: Install Determinate over the existing upstream install in place. Do not uninstall Nix first.
  Rationale: The Determinate installer (source at `github.com/DeterminateSystems/nix-installer`) supports "curing" an existing install. An upstream install has no `/nix/receipt.json`, which is the installer's record of a previous Determinate install, and the installer only refuses when it finds an incompatible receipt. It skips unmounting or recreating a "Nix Store" APFS volume already mounted at `/nix`. It changes ownership of existing `/nix/store` files rather than deleting them. It merges any existing `/etc/nix/nix.conf`. Its "nix-darwin must be removed first" check runs only on uninstall. A coworker of John's has also done this migration without uninstalling.
  Date: 2026-10-29

- Decision: Before running the installer, add a second System-keychain item holding the existing volume password under Determinate's naming (account `Nix Store`, service `Nix Store`, label `disk3 encryption password`, description `Encrypted volume password`). After the install, re-create it so its app access list also includes `/usr/local/bin/determinate-nixd`. Keep the existing UUID-named item until a reboot proves Determinate's mount service unlocks `/nix`, then delete it so one item remains.
  Rationale: Without this the in-place install cannot proceed (see Surprises & Discoveries). `security add-generic-password -T` needs the trusted program to exist. `/usr/local/bin/determinate-nixd` does not exist until the package is installed, so the item is created in two passes. The first pass, before the install, lists only programs that already exist. The second pass, after the install, deletes the item and re-adds it with the full list the installer itself uses: `APFSUserAgent`, `CSUserAgent`, `/usr/bin/security`, `/usr/local/bin/determinate-nixd`. Both passes copy the volume encryption secret, so John runs them himself at that step, not an agent. The alternative, uninstalling and reinstalling, deletes the store, which John rejected. Decrypting the volume first does not help either: the installer then fails because it requires an encrypted volume on a FileVault disk.
  Date: 2026-10-30

- Decision: Move nix-darwin's `/etc/nix/nix.conf` aside before installing instead of copying it in place.
  Rationale: The installer compares settings in an existing `nix.conf` with its own and can fail on conflicts. Milestone 3 regenerates every setting John needs into `nix.custom.conf` anyway, so a merge only adds a way to fail.
  Date: 2026-10-29

- Decision: Drop the QEMU Linux builder VM entirely and use Determinate's Native Linux Builder. The only Linux target is `aarch64-linux`, and `x86_64-linux` is no longer a requirement.
  Rationale: John asked for this on 2026-10-30. Preserving the VM was unnecessary complexity, and x86 support is no longer needed. The Native Linux Builder is part of `determinate-nixd`, uses macOS's built-in Virtualization framework, and needs no configuration in this repository. It requires Determinate Nix 3.8.4 or later and a FlakeHub login (`determinate-nixd login`). This replaces the earlier decision to reuse the VM through `determinateNix.nixosVmBasedLinuxBuilder`. The whole `builders/` directory goes away, and nix-darwin's activation removes the old VM's working directory `/var/lib/linux-builder` and its `org.nixos.linux-builder` service.
  Date: 2026-10-30

- Decision: Leave home-manager's per-user `netrc-file` (the agenix secret `/run/agenix/nix-netrc` in `home/cachix/default.nix`) as it is. Do not move it into `determinateNix.determinateNixd.authentication.additionalNetrcSources`.
  Rationale: Determinate does not allow setting `netrc-file` at the system level, and its daemon refuses to start if a file listed in `additionalNetrcSources` is missing. agenix creates `/run/agenix/*` during activation, so at boot that file could be missing and the daemon would not start. The per-user setting works today because `john` is a trusted user. The required private-cache check in Milestone 3 decides whether this holds. If daemon substitution from `tan.cachix.org` fails with HTTP 401, revisit this decision.
  Date: 2026-10-29

- Decision: Disable Determinate's automatic garbage collection and drop `nix.optimise.automatic` without a replacement.
  Rationale: John's configuration deliberately has `nix.gc.automatic = false` and `keep-outputs`/`keep-derivations = true`. Determinate's background collector, on by default, would silently change that. It must be off from the daemon's very first start, so Milestone 2 seeds `/etc/determinate/config.json` before installing, and nix-darwin takes the file over in Milestone 3. nix-darwin's `nix.optimise.automatic` and `nix.gc.automatic` both assert `nix.enable`, which the Determinate module forces off, so they cannot stay. Store optimisation stays available manually through `just optimize-store`. `auto-optimise-store` stays `false`, because nix-darwin's own documentation says it is known to corrupt the store.
  Date: 2026-10-29

- Decision: Scope is the `Johns-MacBook-Pro` machine only. The `Ava` configuration (`x86_64-darwin`, `machines/ava.nix`) shares the changed modules but is not migrated here, and must not be switched to this configuration until Determinate is installed on it.
  Rationale: The modules in `nixDarwinCommonModules` in `flake.nix` are shared by both machines. John considers x86 support deprecated, so Ava's future is outside this plan.
  Date: 2026-10-30


## Outcomes & Retrospective

(To be filled during and after implementation.)


## Context and Orientation

This repository (`/Users/john/.config/nix-config`) is John's macOS system configuration. It is a Nix flake: `flake.nix` declares its inputs (other flakes such as nixpkgs, nix-darwin, home-manager) and its outputs. The output that matters here is `darwinConfigurations."Johns-MacBook-Pro"`, an `aarch64-darwin` system built from the shared module list `nixDarwinCommonModules` in `flake.nix`. nix-darwin is a tool that builds a macOS system configuration from Nix modules and activates it, that is, installs launchd services and `/etc` files and switches the current system to the new build. Activation is done with `darwin-rebuild switch`. home-manager does the same for per-user files under `~`. It runs as part of nix-darwin activation (`home-manager.darwinModules.home-manager` in `flake.nix`, user modules under `home/`).

A flake only sees files that git tracks. Any new file referenced from `flake.nix` must be committed or staged (`git add <file>`) before `nix` or `darwin-rebuild` can see it. When a flake build fails with "path does not exist", check this first.

Nix today is configured in these places, all of which change in this plan:

`darwin/default.nix` imports `../builders` and sets `nix.enable = true`, `nix.package = pkgs.nixVersions.stable`, a `nix.settings` block (`download-buffer-size`, `trusted-users = [ "john" "@admin" ]`, `auto-optimise-store = false`, `experimental-features = [ "ca-derivations" "nix-command" "flakes" ]`, `builders-use-substitutes`, `keep-outputs`, `keep-derivations`), `nix.gc` (with `automatic = false`), and `nix.optimise.automatic = true`. The same file also declares the agenix secrets `access_token` and `nix-netrc`. agenix is the tool that decrypts `secrets/*.age` into `/run/agenix/` at activation. Never edit `secrets/*.age` directly.

`builders/` holds three files. `builders/default.nix` sets `nix.distributedBuilds = true` and `builders-use-substitutes` and imports the other two. `builders/darwin.builder.nix` enables nix-darwin's `nix.linux-builder`. This is a QEMU virtual machine run by launchd as `org.nixos.linux-builder`, with state in `/var/lib/linux-builder` and an SSH key at `/etc/nix/builder_ed25519`, used as a remote builder for Linux derivations. `builders/nixbuild.nix` only contains a commented-out nixbuild.net entry. This plan deletes the whole directory and its import (see Decision Log).

`flake.nix` itself, in the first element of `nixDarwinCommonModules`, sets `environment.etc."nix/inputs/nixpkgs"`, `nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ]`, and `nix.registry.nixpkgs.flake = inputs.nixpkgs`. These pin `<nixpkgs>` and the `nixpkgs` flake registry entry to the flake's locked nixpkgs. The home-manager part of `flake.nix` (`homeManagerCommonConfig`) already sets the same pins per user: `NIX_PATH` in `home.sessionVariables` and a user `nix.registry`.

home-manager writes the per-user `~/.config/nix/nix.conf` from `home/cachix/default.nix` (`extra-substituters = https://tan.cachix.org`, its public key, `netrc-file = /run/agenix/nix-netrc`) and `home/default.nix` (`nix.extraOptions` with `!include /run/agenix/access_token`, which supplies a GitHub token for private repositories such as `github:topagentnetwork/hchart`). home-manager's nix module asserts that `nix.package` is non-null whenever `nix.settings` or `nix.extraOptions` is set. Inside nix-darwin it gets that value from the system's `nix.package`, but only while `nix.enable` is true (`nixos/common.nix` in the home-manager input: `package = mkIf config.nix.enable config.nix.package`). Once nix-darwin stops managing Nix, home-manager needs its own `nix.package`.

What turning off nix-darwin's Nix management means, verified in the nix-darwin source pinned by `flake.lock`: when `nix.enable = false`, nix-darwin stops writing `/etc/nix/nix.conf`, `/etc/nix/machines`, and `/etc/nix/registry.json`, and stops managing the `org.nixos.nix-daemon` launchd service. Its `nix.settings`, `nix.registry`, `nix.nixPath`, and `nix.extraOptions` are silently ignored. `nix.linux-builder.enable`, `nix.gc.automatic`, and `nix.optimise.automatic` fail the build with assertions such as "`nix.linux-builder.enable` requires `nix.enable`". With `nix.linux-builder` gone, activation also runs nix-darwin's cleanup for it, which removes `/var/lib/linux-builder` and the `org.nixos.linux-builder` launchd service.

The Determinate module (flake `https://flakehub.com/f/DeterminateSystems/determinate/3`, module `darwinModules.default`, source `modules/nix-darwin/default.nix` in `github.com/DeterminateSystems/determinate`) forces `nix.enable = false` and adds options under `determinateNix`. `determinateNix.enable` turns the module on. `determinateNix.customSettings` takes the same keys as `nix.conf` and writes them to `/etc/nix/nix.custom.conf`, which Determinate's own `/etc/nix/nix.conf` includes. It rejects `netrc-file`, `external-builders`, `extra-nix-path`, `ssl-cert-file`, `bash-prompt-prefix`, and `upgrade-nix-store-path-url`. `determinateNix.registry` takes the same shape as `nix.registry` and writes `/etc/nix/registry.json`. `determinateNix.determinateNixd` writes `/etc/determinate/config.json`, including `garbageCollector.strategy` (`"automatic"` or `"disabled"`). The Native Linux Builder is on by default unless `determinateNixd.builder.state = "disabled"` or the module's VM-builder option is enabled. This plan sets neither. Older releases called the option attribute `determinate-nix`. Use `determinateNix`. The same repository has a home-manager module that sets `nix.package = null`. Do not import it, because that would trip the home-manager assertion above.

Determinate's installer is a macOS package, `https://install.determinate.systems/determinate-pkg/stable/Universal`. Determinate Nix is not available through Homebrew. Two installer behaviors matter for an in-place install. First, before it changes anything, it checks the system keychain for the encryption password of the existing FileVault-encrypted "Nix Store" volume. It looks the password up as account `Nix Store`, service `Nix Store`, label `<disk> encryption password`, description `Encrypted volume password`. If the volume is encrypted and no such item exists, it aborts with "The keychain lacks a password for the already existing ... volume". On this machine `diskutil info /nix` reports volume name `Nix Store`, device `disk3s7`, part of whole disk `disk3`, mount point `/nix`, FileVault `Yes`. Second, it installs its own launchd services, `systems.determinate.nix-daemon` and `systems.determinate.nix-store`. It does not stop nix-darwin's `org.nixos.nix-daemon` or the upstream installer's `org.nixos.darwin-store`, so those are cleaned up by hand.

nix-darwin refuses to activate when it would overwrite an `/etc` file it does not already manage, and stops with "Unexpected files in /etc, aborting activation". The Determinate installer creates `/etc/nix/nix.custom.conf`, so that file must be moved aside before the first switch.

`justfile` has `just build`, which runs `darwin-rebuild build --flake .`, and `just switch`. Both pick the configuration by the machine's hostname, which `scutil --get LocalHostName` reports as `Johns-MacBook-Pro`. This plan still names the configuration explicitly with `--flake .#Johns-MacBook-Pro`, so it does not depend on the hostname.

Related local documentation: `docs/nix-workarounds.md` records temporary overrides of upstream breakage and is not affected. There is no `docs/adr/` directory in this repository, so no relevant ADR exists.


## Plan of Work

### Milestone 1: configuration builds with Determinate

This milestone changes only Nix files, and its proof is a successful build. Nothing is activated, so it is safe to do on the current upstream Nix.

In `flake.nix`, add the input `determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";`. Do not add `inputs.nixpkgs.follows`, because Determinate's docs do not use it for this input. Add `inputs.determinate.darwinModules.default` to `nixDarwinCommonModules`. In the first element of that list, keep `environment.etc."nix/inputs/nixpkgs"`, replace `nix.registry.nixpkgs.flake = inputs.nixpkgs;` with `determinateNix.registry.nixpkgs.flake = inputs.nixpkgs;`, and delete `nix.nixPath`, which nix-darwin would now ignore. The user-level `NIX_PATH` set by home-manager still provides `<nixpkgs>` in John's shells. In `homeManagerCommonConfig`, add `nix.package = args.pkgs.nix;` to the existing `(args: { ... })` module. This satisfies home-manager's assertion. The package is only used to check the generated `~/.config/nix/nix.conf`, and the `nix` that actually runs comes from Determinate.

In `darwin/default.nix`, remove `../builders` from `imports`, delete `nix.enable`, `nix.package`, `nix.settings`, `nix.gc`, and `nix.optimise.automatic`, and add a `determinateNix` block:

```nix
  determinateNix = {
    enable = true;
    customSettings = {
      download-buffer-size = 1073741824; # 1024MB
      trusted-users = [
        "john"
        "@admin"
      ];
      # flakes and nix-command are always on in Determinate Nix
      extra-experimental-features = [ "ca-derivations" ];
      keep-outputs = true;
      keep-derivations = true;
    };
    # Keep garbage collection manual, as it was under nix-darwin
    determinateNixd.garbageCollector.strategy = "disabled";
  };

  # The migration seeds /etc/determinate/config.json with exactly this content
  # before Determinate's daemon first starts, so GC is never on. Let nix-darwin
  # replace that seed in place instead of refusing "Unexpected files in /etc".
  # sha256 of {"garbageCollector":{"strategy":"disabled"}} with no trailing newline
  environment.etc."determinate/config.json".knownSha256Hashes = [
    "7b52d4d0deb422fa989806ab44705558f278411c117e3015e3c838c120e7dd6d"
  ];
```

The hash comes from `printf '%s' '{"garbageCollector":{"strategy":"disabled"}}' | shasum -a 256`. Keep it even after the migration. It only allows nix-darwin to overwrite a file with exactly that content, so it is harmless.

Delete `builders/default.nix`, `builders/darwin.builder.nix`, and `builders/nixbuild.nix`. Linux builds go to Determinate's built-in builder, which needs nothing in this repository.

Run `nix flake lock` so `flake.lock` records the new input, then build. If the build fails with an assertion naming a `nix.*` option, some other module still sets an option that needs nix-darwin to manage Nix. Search with `rg -n 'nix\.' darwin machines flake.nix` and move or remove the option. Acceptance is a successful build whose `result/etc/nix/` contains `nix.custom.conf` with the settings above and `registry.json`, but no `nix.conf` and no `machines`, and whose `result/Library/LaunchDaemons/` has no `org.nixos.linux-builder.plist`. Commit with message `feat(nix): configure Determinate Nix via its nix-darwin module` and the ExecPlan trailer. Do not switch yet. Activating this build on upstream Nix would leave nix-darwin restoring the old daemon under a configuration that expects Determinate.

### Milestone 2: install Determinate over the existing install

This milestone changes the machine, not the repository. It needs John at the keyboard, because the installer is a graphical package that asks for an administrator password, and because the keychain steps handle the volume's encryption secret.

First save evidence of the current store: the full list of valid store paths and the target of `/run/current-system`, written to files outside the store. Then John adds the Determinate-named keychain item (first pass) and confirms the installer's own lookup now finds it. Both keychain passes go through one fail-fast script, `~/determinate-migration/keychain-item.sh`, shown in Concrete Steps.

Before the installer starts the Determinate daemon for the first time, write `/etc/determinate/config.json` with garbage collection disabled. Determinate's daemon collects garbage automatically by default, deleting store paths when free disk space runs low. Without this seed, it could delete paths this migration promises to keep, in the window before Milestone 3's switch writes the same setting. The seed contains only `{"garbageCollector":{"strategy":"disabled"}}`. The file nix-darwin generates later holds more: the module also writes the Native Linux Builder defaults, so it evaluates to `{"builder":{"cpuCount":1,"memoryBytes":8589934592},"garbageCollector":{"strategy":"disabled"}}`. The two files differ, but both disable collection, and that one setting is what the checks test. The installer source has no code that writes this file.

Then move nix-darwin's `/etc/nix/nix.conf` symlink aside so the installer writes a fresh file, stop nix-darwin's daemon (`org.nixos.nix-daemon`) so two daemons do not fight over the socket `/nix/var/nix/daemon-socket/socket`, and run the Determinate package. Once `/usr/local/bin/determinate-nixd` exists, John re-creates the keychain item with the full access list (second pass). If either pass fails, stop: do not continue to Milestone 3 and do not reboot. Finally, log in to FlakeHub so the Native Linux Builder can start. `determinate-nixd login` uses token authentication by default, so John first creates a token at `https://flakehub.com/user/settings?editview=tokens`, then pastes it when the command asks. `determinate-nixd status` shows the login state.

Acceptance: `/nix/var/nix/profiles/default/bin/nix --version` prints `Determinate Nix`. Plain `nix` still resolves to nix-darwin's copy until Milestone 3. `launchctl print system/systems.determinate.nix-daemon` shows it running. `/etc/nix/nix.conf` contains `!include nix.custom.conf`. `/etc/determinate/config.json` still holds the seeded content. The saved current-system path is still valid. No path from the saved list is missing from the store; the comparison in Concrete Steps prints `0`. Also list `/nix/var/nix/profiles/default/Library/LaunchDaemons/`. If it now contains `org.nixos.nix-daemon.plist`, expect nix-darwin's switch in Milestone 3 to restore that daemon (see below).

### Milestone 3: activate the configuration on Determinate Nix

nix-darwin refuses to overwrite an `/etc` file it does not manage unless the file's hash is listed in `environment.etc.<name>.knownSha256Hashes`. That check is in `modules/system/etc.nix` of the nix-darwin input. The seeded `/etc/determinate/config.json` is never removed. Milestone 1 lists its hash, so activation replaces it in place with nix-darwin's generated file. That file also disables collection, so collection stays disabled the whole time. The installer's `/etc/nix/nix.custom.conf` has content that cannot be known in advance, so it is moved aside instead. That happens only after the new system is already built, so the gap is just activation. A daemon restart during that gap would lose only the custom settings, such as `trusted-users`, not the garbage-collection setting. Milestone 3 runs as one fail-fast script, `~/determinate-migration/switch.sh`. If activation fails, it puts `nix.custom.conf` back when nothing has replaced it, exits non-zero, and nothing after it runs. The service cleanup and reboot happen only after the script prints `switch ok`. The switch itself is `sudo darwin-rebuild switch --flake .#Johns-MacBook-Pro`. Activation removes nix-darwin's `org.nixos.nix-daemon` plist and the old `org.nixos.linux-builder` VM service and directory, and writes `nix.custom.conf`, `registry.json`, and `/etc/determinate/config.json`. With `nix.enable` off, nix-darwin's activation script restores an "unmanaged" `org.nixos.nix-daemon` from `/nix/var/nix/profiles/default/Library/LaunchDaemons/org.nixos.nix-daemon.plist` if that file exists. This is in `modules/nix/default.nix` of the nix-darwin input (the `handleUnmanaged` function), and the Determinate module does not override it. If the switch prints "restoring unmanaged Nix daemon...", stop that daemon and move its plist aside as shown in Concrete Steps, so only `systems.determinate.nix-daemon` serves the socket. Remove the leftover old builder key `/etc/nix/builder_ed25519` and its `.pub` (nothing uses them any more). If `/Library/LaunchDaemons/systems.determinate.nix-store.plist` exists, move the upstream installer's `/Library/LaunchDaemons/org.nixos.darwin-store.plist` aside, so that exactly one service mounts `/nix` at boot. Then reboot and run every check in Validation and Acceptance.

Only after a reboot passes those checks with the upstream mount service moved aside, delete the old UUID-named keychain item. That leaves exactly one keychain item for the volume. At that point the only thing that unlocks `/nix` at boot is `systems.determinate.nix-store`, which runs `/usr/local/bin/determinate-nixd init` and reads the Determinate-named item. `determinate-nixd` lives outside `/nix`, so mounting does not depend on the volume it mounts. Nothing macOS itself needs at boot lives in `/nix`. Every nix-darwin launchd service, such as `org.nixos.activate-system` and `org.nixos.activate-agenix`, starts with `/bin/wait4path /nix/store`, so it waits for the mount instead of failing. The reboot gate matters because the old item is what the recovery path in Idempotence and Recovery depends on.

To close the plan, record evidence in Progress, triage any friction, and fill in Outcomes & Retrospective. Create `docs/adr/` with one ADR recording that Nix on this machine is Determinate Nix, configured only through `determinateNix.*` and never `nix.*`, with Linux builds on the Native Linux Builder. That keeps future edits from reintroducing nix-darwin `nix.*` options or a builder VM.


## Concrete Steps

All commands run from `/Users/john/.config/nix-config` unless stated otherwise.

Milestone 1:

```bash
nix flake lock
git rm builders/default.nix builders/darwin.builder.nix builders/nixbuild.nix
git add flake.nix flake.lock darwin/default.nix
darwin-rebuild build --flake .#Johns-MacBook-Pro
ls result/etc/nix/
ls result/Library/LaunchDaemons/
cat result/etc/nix/nix.custom.conf
```

Expected: `result/etc/nix/` contains `nix.custom.conf`, `registry.json`, and `inputs`, and does not contain `nix.conf` or `machines`. `result/Library/LaunchDaemons/` does not contain `org.nixos.linux-builder.plist`. `nix.custom.conf` contains, in some order:

```text
# This custom configuration file for Determinate Nix is generated by the determinate module for nix-darwin.
...
download-buffer-size = 1073741824
extra-experimental-features = ca-derivations
keep-derivations = true
keep-outputs = true
trusted-users = john @admin
```

Milestone 2 preflight. Save the store evidence to `~/determinate-migration/`, outside the store. The `security` lookup prints only item metadata, never the password, because it is run without `-w`:

```bash
mkdir -p ~/determinate-migration
nix path-info --all | sort > ~/determinate-migration/paths-before.txt
readlink /run/current-system > ~/determinate-migration/current-system.txt
wc -l ~/determinate-migration/paths-before.txt
security find-generic-password -a "Nix Store" -s "Nix Store" \
  -l "disk3 encryption password" -D "Encrypted volume password" \
  /Library/Keychains/System.keychain >/dev/null && echo keychain-ok
```

On 2026-10-29 the lookup did not print `keychain-ok`. Both keychain passes use one script, saved as `~/determinate-migration/keychain-item.sh`. It stops at the first failure. It reads the existing UUID-named item's password and refuses to go on if the password is empty, before it deletes anything. It replaces the Determinate-named item. Then it reads the new item back and checks that it holds the same password, without printing either. `first` lists only programs that exist before the install. `second` requires `/usr/local/bin/determinate-nixd` and adds it to the item's allowed programs. Like the installer itself, the script passes the password to `security add-generic-password -w`, so it appears briefly in that process's arguments.

```bash
#!/usr/bin/env bash
# Usage: sudo bash ~/determinate-migration/keychain-item.sh first|second
set -euo pipefail

kc=/Library/Keychains/System.keychain
old_service=1F62D489-B73B-4A98-A5E1-978E440B8A1B
item=(-a "Nix Store" -s "Nix Store" -l "disk3 encryption password")
trusted=(
  -T /System/Library/CoreServices/APFSUserAgent
  -T /System/Library/CoreServices/CSUserAgent
  -T /usr/bin/security
)

fail() { echo "keychain-item: $*; do not reboot or continue" >&2; exit 1; }

[[ $EUID -eq 0 ]] || fail "run with sudo"
case "${1:-}" in
  first) ;;
  second)
    [[ -x /usr/local/bin/determinate-nixd ]] || fail "/usr/local/bin/determinate-nixd is missing"
    trusted+=(-T /usr/local/bin/determinate-nixd)
    ;;
  *) fail "usage: $0 first|second" ;;
esac

pw=$(security find-generic-password -s "$old_service" -w "$kc") || fail "cannot read the UUID-named item"
trap 'unset pw copy' EXIT
[[ -n $pw ]] || fail "the UUID-named item returned an empty password"

# Only now, with a verified password in hand, replace the Determinate-named item
if security find-generic-password "${item[@]}" "$kc" >/dev/null 2>&1; then
  security delete-generic-password "${item[@]}" "$kc" >/dev/null || fail "cannot delete the old Determinate-named item"
fi
security add-generic-password "${item[@]}" -D "Encrypted volume password" \
  -j "Added for the Determinate Nix in-place install" \
  -w "$pw" "${trusted[@]}" "$kc" || fail "cannot add the Determinate-named item"

copy=$(security find-generic-password "${item[@]}" -w "$kc") || fail "cannot read back the new item"
[[ $copy == "$pw" ]] || fail "the new item does not hold the same password"
echo "keychain-item: $1 pass ok"
```

John runs the first pass himself, then re-runs the lookup above:

```bash
sudo bash ~/determinate-migration/keychain-item.sh first   # expect: keychain-item: first pass ok
```

If it prints an error, stop here. The UUID-named item and the current mount service are untouched, so the machine is as it was. Otherwise seed the disabled garbage collector, record free space, move nix-darwin's `nix.conf` aside, stop its daemon, and install:

```bash
sudo mkdir -p /etc/determinate
printf '%s' '{"garbageCollector":{"strategy":"disabled"}}' | sudo tee /etc/determinate/config.json >/dev/null
cat /etc/determinate/config.json; echo                               # {"garbageCollector":{"strategy":"disabled"}}
df -h /nix > ~/determinate-migration/df-before.txt
ls -l /etc/nix/nix.conf                                              # a symlink into /etc/static
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-determinate
sudo launchctl bootout system/org.nixos.nix-daemon
curl -fsSL -o ~/Downloads/Determinate.pkg https://install.determinate.systems/determinate-pkg/stable/Universal
open ~/Downloads/Determinate.pkg      # run the installer GUI to completion
```

Right after the installer finishes, confirm the seed survived. If it did not, re-run the `printf ... | sudo tee` line above at once, then restart the daemon with `sudo launchctl kickstart -k system/systems.determinate.nix-daemon` so it reads the file:

```bash
cat /etc/determinate/config.json; echo                               # still {"garbageCollector":{"strategy":"disabled"}}
```

Second keychain pass, run by John, now that `/usr/local/bin/determinate-nixd` exists. It replaces the item with one whose access list matches the installer's own. A failure here leaves the old mount service and the UUID-named item in place, so `/nix` still mounts at boot. Even so, stop and do not start Milestone 3:

```bash
sudo bash ~/determinate-migration/keychain-item.sh second  # expect: keychain-item: second pass ok
```

Then log in to FlakeHub. First create a token at `https://flakehub.com/user/settings?editview=tokens`, then paste it when `determinate-nixd login` asks. Check the install in a new terminal:

```bash
determinate-nixd login
determinate-nixd status                                              # shows the FlakeHub login
/nix/var/nix/profiles/default/bin/nix --version
sudo launchctl print system/systems.determinate.nix-daemon | head -5
cat /etc/nix/nix.conf
nix path-info "$(cat ~/determinate-migration/current-system.txt)" >/dev/null && echo current-system-ok
nix path-info --all | sort > ~/determinate-migration/paths-after.txt
comm -23 ~/determinate-migration/paths-before.txt ~/determinate-migration/paths-after.txt | wc -l
ls /nix/var/nix/profiles/default/Library/LaunchDaemons/ 2>&1
```

Expected: `nix (Determinate Nix 3.x.y) 2.x.y`. The service is printed with `state = running`. `nix.conf` contains `!include nix.custom.conf`. `current-system-ok` is printed. The `comm` count is `0`, meaning no path that existed before is missing now.

Milestone 3:

```bash
#!/usr/bin/env bash
# Save as ~/determinate-migration/switch.sh; run as john: bash ~/determinate-migration/switch.sh
set -euo pipefail

fail() { echo "switch.sh: $*; stop: no service cleanup, no reboot" >&2; exit 1; }
config=/etc/determinate/config.json
seed_sha=7b52d4d0deb422fa989806ab44705558f278411c117e3015e3c838c120e7dd6d
custom=/etc/nix/nix.custom.conf
aside=/etc/nix/nix.custom.conf.before-nix-darwin

managed() { [[ $(readlink "$1") == "/etc/static/${1#/etc/}" ]]; }
gc_disabled() { [[ $(/usr/bin/plutil -extract garbageCollector.strategy raw -o - "$config") == disabled ]]; }

cd /Users/john/.config/nix-config

# First run: config.json must be the exact seed, whose hash darwin/default.nix lists.
# Retry after a successful activation: it is nix-darwin's file, which also disables GC.
if managed "$config"; then
  gc_disabled || fail "$config is managed but does not disable garbage collection"
else
  [[ $(/usr/bin/shasum -a 256 "$config" | cut -d' ' -f1) == "$seed_sha" ]] || fail "$config is not the exact seed"
fi

# Build first, so the window with nix.custom.conf moved aside is only activation
darwin-rebuild build --flake .#Johns-MacBook-Pro || fail "build failed; nothing was changed"

# Move the installer's nix.custom.conf aside only while nix-darwin does not manage it yet
if [[ -e $custom ]] && ! managed "$custom"; then
  sudo mv "$custom" "$aside" || fail "cannot move $custom aside"
fi
if ! sudo darwin-rebuild switch --flake .#Johns-MacBook-Pro; then
  if [[ ! -e $custom && -e $aside ]]; then
    sudo mv "$aside" "$custom" || fail "activation failed AND restoring $custom failed"
  fi
  fail "activation failed"
fi

managed "$config" || fail "$config is not managed by nix-darwin"
gc_disabled || fail "$config does not disable garbage collection"
managed "$custom" || fail "$custom is not managed by nix-darwin"
echo "switch ok"
```

Run it and continue only if the last line is `switch ok`. A non-zero exit means stop and record what it printed:

```bash
bash ~/determinate-migration/switch.sh; echo "exit=$?"               # expect: switch ok, exit=0
ls /Library/LaunchDaemons | rg -i 'nix|determinate|linux-builder'
```

Expected launchd plists afterwards: `systems.determinate.nix-daemon.plist` and `systems.determinate.nix-store.plist`, plus nix-darwin's own `org.nixos.activate-system.plist` and `org.nixos.activate-agenix.plist`. `org.nixos.linux-builder.plist` and `org.nixos.nix-daemon.plist` should be gone. If the switch printed "restoring unmanaged Nix daemon..." and `org.nixos.nix-daemon.plist` is back, stop it and move it aside:

```bash
sudo launchctl bootout system/org.nixos.nix-daemon
sudo mv /Library/LaunchDaemons/org.nixos.nix-daemon.plist ~/determinate-migration/org.nixos.nix-daemon.plist.bak
```

Remove the old builder key, and move the upstream volume-mount service aside if Determinate's replacement exists:

```bash
sudo rm -f /etc/nix/builder_ed25519 /etc/nix/builder_ed25519.pub
test -e /Library/LaunchDaemons/systems.determinate.nix-store.plist && {
  sudo launchctl bootout system/org.nixos.darwin-store
  sudo mv /Library/LaunchDaemons/org.nixos.darwin-store.plist ~/determinate-migration/org.nixos.darwin-store.plist.bak
}
```

Then reboot and run the checks in Validation and Acceptance. Once they all pass, John consolidates to one keychain item. Confirm the Determinate mount service did the mounting, then delete the old item:

```bash
sudo launchctl print system/systems.determinate.nix-store | rg 'last exit code'   # expect: last exit code = 0
test ! -e /Library/LaunchDaemons/org.nixos.darwin-store.plist && echo old-mount-service-gone
sudo security delete-generic-password -s '1F62D489-B73B-4A98-A5E1-978E440B8A1B' /Library/Keychains/System.keychain
security find-generic-password -s "Nix Store" /Library/Keychains/System.keychain >/dev/null && echo determinate-item-present
```

Reboot once more and re-run `mount | rg ' on /nix '`. `/nix` must still be mounted. After that, the backup `~/determinate-migration/org.nixos.darwin-store.plist.bak` is useless, because it reads the item just deleted, and can be removed.


## Validation and Acceptance

Milestone 1 is accepted when `darwin-rebuild build --flake .#Johns-MacBook-Pro` exits 0 and the `result/` listings and `nix.custom.conf` content match Concrete Steps.

Milestone 2 is accepted when `/nix/var/nix/profiles/default/bin/nix --version` contains `Determinate Nix`, the Determinate daemon is running, `current-system-ok` is printed, and the `comm` count of paths missing since the preflight is `0`.

Milestone 3 is accepted when every one of the following holds after a reboot. Each is required:

```bash
mount | rg ' on /nix '                           # /nix is mounted (by systems.determinate.nix-store)
nix --version                                    # contains "Determinate Nix"
nix config show | rg 'trusted-users|keep-outputs|experimental-features|download-buffer-size'
# expect: trusted-users includes john and @admin; keep-outputs = true;
# experimental-features includes ca-derivations, flakes, nix-command
plutil -extract garbageCollector.strategy raw -o - /etc/determinate/config.json   # disabled
nix registry list | rg nixpkgs                   # system entry points at a path: /nix/store/...-source
nix build --no-link --print-out-paths --rebuild nixpkgs#legacyPackages.aarch64-linux.hello
# succeeds; it was built on the Native Linux Builder, not downloaded
nix flake metadata --refresh github:topagentnetwork/hchart
# succeeds; this repository is private, so it proves the agenix access token is used
darwin-rebuild build --flake .#Johns-MacBook-Pro # still builds on Determinate Nix
```

`--rebuild` forces a real build even though `hello` is in the public cache. That is what proves the Linux builder works. If `--rebuild` complains that the path is not valid locally, run the build once without it, then again with it.

The private-cache check is also required, and it must go through the daemon. The path used is `P` = `/nix/store/8m8dch6jvhhsriknppc788m0281zhb7q-tan-aeson-0.1.0.0`. It is the `aarch64-darwin` build of `tan-aeson` from `~/code/TAN/libs/tan-commons`, which that repository's CI pushes to the `tan` cache. On 2026-10-30 it was in `tan.cachix.org` and not in the local store. Re-check both during Milestone 2's preflight, because a cache can evict paths and a local build could add it. `nix path-info --store https://tan.cachix.org /nix/store/8m8dch6jvhhsriknppc788m0281zhb7q-tan-aeson-0.1.0.0` must print the path, and `nix path-info /nix/store/8m8dch6jvhhsriknppc788m0281zhb7q-tan-aeson-0.1.0.0` must fail with "is not valid". If either check no longer holds, pick another output from the same repository with `nix eval --raw .#packages.aarch64-darwin.<name>` and repeat both checks. After the reboot, run:

```bash
nix-store --realise /nix/store/8m8dch6jvhhsriknppc788m0281zhb7q-tan-aeson-0.1.0.0
```

It must print the path and show that it was copied from `https://tan.cachix.org`. If it fails with HTTP 401, the per-user `netrc-file` is not reaching the daemon, and the `netrc-file` decision in the Decision Log must be revisited before the plan can be accepted.


## Idempotence and Recovery

Milestone 1 is pure configuration. Re-running the build is harmless, and `git restore`/`git revert` undoes it. Until Milestone 2 is done, this commit must not be switched on any machine. That includes Ava, which shares the modules.

In Milestone 2, the preflight files in `~/determinate-migration/` can be regenerated at any time before the install. The moved-aside `/etc/nix/nix.conf.before-determinate` can be moved back to undo the preflight. The Determinate-named keychain item is harmless if the install is abandoned. It can be removed with `sudo security delete-generic-password -a "Nix Store" -s "Nix Store" -l "disk3 encryption password" /Library/Keychains/System.keychain`, which never touches the UUID-named item the current mount service uses. Both keychain passes can be repeated. The script replaces the Determinate-named item only after it has read a non-empty password, and verifies the copy before it reports success. If the Determinate install is abandoned, remove the seeded `/etc/determinate/config.json`. `nix.conf.orig` already exists in `/etc/nix` from the original upstream install and must not be touched.

If the installer fails during planning, for example because of the keychain check, it has changed nothing. Move `nix.conf.before-determinate` back to `/etc/nix/nix.conf`, restart the old daemon with `sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist`, and stop. If it fails partway, `/nix/receipt.json` and `/nix/nix-installer` exist. Do not run `/nix/nix-installer uninstall`: an uninstall deletes the store, which is the outcome this plan avoids. Instead re-run the package, which picks up its receipt, and record the failure as friction and in Surprises & Discoveries.

In Milestone 3, `switch.sh` can be re-run after any failure, including after an activation that succeeded but a later check failed. Before activation it requires the exact seed (checked by hash). After activation it accepts nix-darwin's managed file, as long as collection is disabled. It moves `nix.custom.conf` aside only while that file is still the installer's. If activation aborts with "Unexpected files in /etc", the message names the file. If that file is `/etc/determinate/config.json`, its content is not the seed, and its hash in `darwin/default.nix` no longer matches. Do not move it aside, because that would leave the daemon without the disabled-collection setting. Rewrite the seed with the `printf ... | sudo tee` line from Milestone 2 and re-run. For any other named file, move it aside with a `.before-nix-darwin` suffix and re-run. If `/nix` is not mounted after the first reboot, Determinate's mount service could not unlock the volume. Restore the upstream mount service so the machine boots with a working store, then record the failure and stop. This works only while the old UUID-named keychain item still exists, which is why that item is deleted last:

With `/nix` unmounted, John's login shell `/run/current-system/sw/bin/zsh` (checked with `dscl . -read /Users/john UserShell`) does not exist, so a normal Terminal window closes at once with "[Process completed]". Get a shell that does not touch `/nix`. In Terminal, choose Shell > New Command… (Shift-Command-N), enter `/bin/bash --noprofile --norc`, and press Run. That shell's `PATH` may still include `/nix/...` or `/run/...` entries, so use full macOS paths for every command:

```bash
/usr/bin/sudo /bin/mv ~/determinate-migration/org.nixos.darwin-store.plist.bak /Library/LaunchDaemons/org.nixos.darwin-store.plist
/usr/bin/sudo /bin/launchctl bootstrap system /Library/LaunchDaemons/org.nixos.darwin-store.plist
/sbin/mount | /usr/bin/grep ' on /nix '                              # /nix is mounted again
```
`sudo darwin-rebuild --rollback` returns to the previous generation, but do not use it while Determinate Nix is installed. The previous generation re-enables nix-darwin's own `org.nixos.nix-daemon` and the old builder VM, and its daemon would conflict with Determinate's. Fix forward on the Determinate configuration instead. Moved-aside plists and config files are kept, not deleted, so they can be restored by hand.


## Interfaces and Dependencies

The new flake input is `determinate` (`https://flakehub.com/f/DeterminateSystems/determinate/3`), and the module used is `inputs.determinate.darwinModules.default`. The options this plan depends on are `determinateNix.enable`, `determinateNix.customSettings`, `determinateNix.registry`, and `determinateNix.determinateNixd.garbageCollector.strategy`. If a future module release renames them, the build fails with an unknown-option error. Check the module source in the locked input with `nix eval --raw --impure --expr '(builtins.getFlake (toString ./.)).inputs.determinate.outPath'` and read `modules/nix-darwin/default.nix` under that path.

Software and services outside the flake: the Determinate macOS package provides `/usr/local/bin/determinate-nixd` and the launchd services `systems.determinate.nix-daemon` and `systems.determinate.nix-store`. The Native Linux Builder runs inside `determinate-nixd` and needs a FlakeHub login and Determinate Nix 3.8.4 or later. `determinate-nixd login` uses a FlakeHub token created at `https://flakehub.com/user/settings?editview=tokens`. Later upgrades of Determinate Nix itself use `sudo determinate-nixd upgrade`, not `nix.package` and not Homebrew.

Unchanged dependencies that must keep working: the agenix secrets `access_token` and `nix-netrc` declared in `darwin/default.nix`, the home-manager-generated `~/.config/nix/nix.conf`, and the private `tan.cachix.org` substituter.


## Revision Notes

- 2026-10-30: Revised after the `gpt-6-astra` review (changes requested) and John's direction. The QEMU builder VM and `x86_64-linux` support were dropped in favor of Determinate's Native Linux Builder for `aarch64-linux`; this makes the review's VM-deletion and x86-emulation findings moot. The keychain step is now two passes, so no `-T` names a missing program. Store preservation is now checked against a saved path list and the saved current-system target. The private-cache check, now through the daemon, and a private-repository fetch for the access token are required acceptance. The hostname note was corrected.
- 2026-10-30: Revised after the second `gpt-6-astra` review (changes requested). Garbage collection is now disabled by seeding `/etc/determinate/config.json` before the daemon first starts, and nix-darwin takes the file over during the switch. Both keychain passes go through one fail-fast script that verifies the password before deleting anything and verifies the copy afterwards. Recovery now explains how to get a shell when `/nix` is not mounted. FlakeHub login uses a token, not a browser. The old UUID-named keychain item is deleted after a verified reboot, leaving one item.
- 2026-10-30: Revised after the third `gpt-6-astra` review (changes requested). The seeded `/etc/determinate/config.json` is no longer moved aside: its hash goes into `environment.etc."determinate/config.json".knownSha256Hashes` in `darwin/default.nix`, so nix-darwin replaces it in place and collection stays disabled throughout activation. Milestone 3's switch is now a fail-fast script that builds first, propagates activation failure with a non-zero exit, checks that restoring `nix.custom.conf` worked, and blocks cleanup and reboot unless it prints `switch ok`.
- 2026-10-30: Revised after the fourth `gpt-6-astra` review (changes requested). The generated `config.json` also contains the Native Linux Builder defaults, so it is not identical to the seed, contrary to the previous revision. `switch.sh` now requires the exact seed, by hash, only while the file is unmanaged. After activation it checks that `garbageCollector.strategy` is `disabled` and that the file is a nix-darwin link, so retries after a successful activation pass.
