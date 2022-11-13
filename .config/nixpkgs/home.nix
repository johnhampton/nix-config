{ config, pkgs, plugin-foreign-env, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "john";
  home.homeDirectory = "/Users/john";

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



  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
