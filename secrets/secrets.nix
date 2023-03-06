let
  john = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm";
in
{
  "netrc.age".publicKeys = [ john ];
  "hosts.yml.age".publicKeys = [ john ];
}
