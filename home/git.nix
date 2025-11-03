{ config, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "John Hampton";
        email = "john.hampton@stanfordalumni.org";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org";
      };
      alias = {
        fix-commit = "commit --edit --file=.git/COMMIT_EDITMSG";
        use-tan-email = "config user.email \"john@topagentnetwork.com\"";
        diff-side-by-side = "-c delta.features=side-by-side diff";
      };
      credential = { helper = "osxkeychain"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "master"; };
      mergetool = { prompt = false; };
      merge = { tool = "nvimdiff"; };
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      };
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
    ignores = [
      # General
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon"

      # Thumbnails
      "._*"

      # Files that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"

      # Directories potentially created on remote AFP share
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      ".direnv"
      ".devenv"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "chameleon";
    };
  };
  xdg.configFile."git/allowed_signers".text = ''
    john@topagentnetwork.com  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org
    john.hampton@stanfordalumni.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org
  '';

}
