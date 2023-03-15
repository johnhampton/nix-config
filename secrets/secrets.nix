let
  john = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm";
  ava = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEodqrdAypJCvC1lSmz7Lks1psvI/Iy50sGhthhxHS9g";
  mbp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9X+vBMznLwiHTJPtkEq9NEpa/0/3Tdw0owRsgIwyJc";

in
{
  "netrc.age".publicKeys = [ john ava mbp ];
  "hosts.yml.age".publicKeys = [ john ava mbp ];
  "access_tokens.conf.age".publicKeys = [ john ava mbp ];
  "id_ed25519.age".publicKeys = [ john ava mbp ];
  "npmrc.age".publicKeys = [ john ava mbp ];
}
