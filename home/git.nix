{ config, ... }: {
  programs.git.enable = true;
  programs.git = {
    userName = "John Hampton";
    userEmail = "john.hampton@stanfordalumni.org";
    aliases = {
      fix-commit = "commit --edit --file=.git/COMMIT_EDITMSG";
      use-tan-email = "config user.email \"john@topagentnetwork.com\"";
    };
    delta.enable = true;
    delta.options = {
      features = "chameleon";
    };
    extraConfig = {
      credential = { helper = "osxkeychain"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "master"; };
      "mergetool \"nvim\"" = {
        cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
      };
      mergetool = { prompt = false; };
      merge = { tool = "nvim"; };

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
  xdg.configFile."git/allowed_signers".text = ''
    john@topagentnetwork.com  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org
    john.hampton@stanfordalumni.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org
  '';

}
