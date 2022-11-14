{ config, pkgs, plugin-foreign-env, ... }:

{
  home.packages = with pkgs; [
    kind
    kubectl
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ cloud_sql_proxy gke-gcloud-auth-plugin ]))
    watchman
    yadm
  ];

  programs.autojump.enable = true;

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = true;
  programs.fish = {
    plugins = [
      {
        name = "plugin-foreign-env";
        src = plugin-foreign-env;
      }
    ];

    shellInit = ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';
  };

  programs.just.enable = true;

  # https://starship.rs/config/
  programs.starship.enable = true;
}
