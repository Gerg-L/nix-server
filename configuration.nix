_: {pkgs, ...}: {
  environment = {
    defaultPackages = []; #don't install anything by default
    systemPackages = [
      pkgs.efibootmgr #efi editor
      pkgs.pciutils #lspci
      pkgs.bottom #view tasks
      pkgs.nix-tree #view packages
    ];
  };
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };
  nixpkgs.allowedUnfree = [];

  #enable ssh
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  users = {
    mutableUsers = false;
    users.root = {
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWbwkFJmRBgyWyWU+w3ksZ+KuFw9uXJN3PwqqE7Z/i8 gerg@gerg-desktop"
        #TODO make duplex make a ssh key
      ];
    };
  };
  networking = {
    hostName = "duplex-server";
    nameservers = ["1.1.1.1" "1.0.0.1"];
    defaultGateway = "";
    interfaces = {
      "br0" = {
        name = "br0";
        macAddress = "";
        ipv4.addresses = [
          {
            address = "";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "";
            prefixLength = 64;
          }
        ];
      };
    };
    bridges."br0".interfaces = ["eth0"];
    firewall = {
      allowPing = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  #time settings
  time.timeZone = "America/New_York";
  services = {
    timesyncd = {
      enable = true;
      servers = [
        "time.cloudflare.com"
      ];
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";

  ##TODO get ip address and gateway
  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };
  system.stateVersion = "23.05";
}
