# Secrets every host receives unconditionally.
# Format mirrors sops-nix: keys are secret paths, values are sops option attrsets.
#
# To add host-specific secrets or override options for a specific machine,
# create hosts/<hostname>/secrets.nix in the same format. Host values take
# precedence over globals for any conflicting keys.
{
  "users/maddux/password" = {neededForUsers = true;};
  "vpn/home_server/public_key" = {};
  "vpn/home_server/private_key" = {};
  "vpn/home_server/preshared_key" = {};
}
