{
  config,
  pkgs,
  lib,
  ...
}: let
  port = 51820;
  interfacePublicKey = "HSdq+ye77lpX8cRJY1Gp2+lrKMbSPaq9/M7OII1wFQc=";
  interfaceName = "wg0";
in {
  networking = lib.mkIf false {
    firewall = {
      allowedUDPPorts = [port];
      trustedInterfaces = [interfaceName];
    };
    wg-quick.interfaces = {
      "${interfaceName}" = {
        autostart = false;
        address = ["10.10.10.3/32"];
        listenPort = port;
        privateKeyFile = config.sops.secrets."vpn/home_server/private_key".path;
        peers = [
          {
            publicKey = interfacePublicKey;
            presharedKeyFile = config.sops.secrets."vpn/home_server/preshared_key".path;
            endpoint = "maddux.dev:${toString port}";
            # allowedIPs = [ "192.168.1.0/24" "10.10.10.1/24" ];
            allowedIPs = ["0.0.0.0/0"];
            # allowedIPs = [ "10.253.0.1/32" "192.168.86.0/24" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
