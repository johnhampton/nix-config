{ config, lib, pkgs, ... }:
let
  # Shared starship settings. The nix-store variant disables `pulumi`
  # because its upward search enumerates /nix/store (~3M entries) and
  # hangs the prompt for seconds whenever cwd is under the store.
  starshipSettings = {
    command_timeout = 2000;
    aws.disabled = true;
  };
  starshipNixStoreSettings = starshipSettings // {
    pulumi.disabled = true;
  };
in
{
  # https://starship.rs/config/
  programs.starship.enable = true;
  programs.starship = {
    enableZshIntegration = true;
    settings = starshipSettings;
  };

  xdg.configFile."starship-nix-store.toml".source =
    (pkgs.formats.toml { }).generate "starship-nix-store.toml" starshipNixStoreSettings;

  # Swap STARSHIP_CONFIG when cwd crosses into/out of /nix/store.
  programs.zsh.initContent = lib.mkOrder 700 ''
    autoload -Uz add-zsh-hook
    # Save/restore so we don't clobber a STARSHIP_CONFIG set elsewhere
    # (zshenv, direnv, manual export). Sentinel "__unset__" preserves
    # the "was unset" vs "was empty string" distinction.
    chpwd_starship_nix_store() {
      case "$PWD" in
        /nix/store|/nix/store/*)
          if [[ -z ''${_STARSHIP_CONFIG_SAVED+x} ]]; then
            _STARSHIP_CONFIG_SAVED=''${STARSHIP_CONFIG-__unset__}
          fi
          export STARSHIP_CONFIG="$HOME/.config/starship-nix-store.toml"
          ;;
        *)
          if [[ -n ''${_STARSHIP_CONFIG_SAVED+x} ]]; then
            if [[ $_STARSHIP_CONFIG_SAVED == "__unset__" ]]; then
              unset STARSHIP_CONFIG
            else
              export STARSHIP_CONFIG=$_STARSHIP_CONFIG_SAVED
            fi
            unset _STARSHIP_CONFIG_SAVED
          fi
          ;;
      esac
    }
    add-zsh-hook chpwd chpwd_starship_nix_store
    chpwd_starship_nix_store
  '';
}
