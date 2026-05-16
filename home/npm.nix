{ ... }:
{
  # npm's "globalconfig" tier — $PREFIX/etc/npmrc, where $PREFIX = ~/.npm-global
  # per the `prefix=` line in the user ~/.npmrc. Keeps policy out of the
  # agenix-encrypted .npmrc that holds auth tokens. Requires npm >= 11.10.
  home.file.".npm-global/etc/npmrc".text = ''
    # Refuse package versions published in the last N days — supply-chain embargo.
    min-release-age=7
  '';
}
