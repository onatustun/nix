{
  flake.nixosConfigurations.laptop.module = { pkgs, ... }: {
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      printing = {
        enable = true;

        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      cacert
      cups
      dhcpcd
      dnsutils
      ethtool
      geteduroam
      geteduroam-cli
      iw
      mtr
      networkmanager-openconnect
      openconnect
      openvpn
      p7zip
      rclone
      sshuttle
      syncthing
      tcpdump
      unzip
      wireguard-tools
    ];
  };
}
