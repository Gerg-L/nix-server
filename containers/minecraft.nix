_: {
  containers."minecraft" = {
    privateNetwork = true;
    hostBridge = "br0";
    #localAddress = ""; #TODO
    #localAddress6 = ""; #TODO
    bindMounts."/mnt/minecraft" = {
      mountPoint = "/minecraft";
      hostPath = "/mnt/minecraft";
      isReadOnly = false;
    };
    config = {pkgs, ...}: let
      stopScript = pkgs.writeShellScript "minecraft-server-stop" ''
        echo stop > /run/minecraft-server.stdin
        # Wait for the PID of the minecraft server to disappear before
        # returning, so systemd doesn't attempt to SIGKILL it.
        while kill -0 "$1" 2> /dev/null; do
          sleep 1s
        done
      '';
    in {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = [pkgs.neovim];
      networking = {
        #defaultGateway = ""; #TODO
        nameservers = ["1.1.1.1" "1.0.0.1"];
        firewall = {
          allowedUDPPorts = [25565];
          allowedTCPPorts = [25565];
        };
      };
      #dirty hack to set the mac address
      systemd.services.setmacaddr = {
        script = ''
           /run/current-system/sw/bin/ip link set dev eth0 address 00:00:00:00:00:10 #TODO
          /run/current-system/sw/bin/systemctl stop dhcpcd.service
           /run/current-system/sw/bin/ip addr flush eth0
           /run/current-system/sw/bin/systemctl start dhcpcd.service
        '';
        wantedBy = ["basic.target"];
        after = ["dhcpcd.service"];
      };
      system.stateVersion = "23.05";
      users.users.minecraft = {
        description = "Minecraft server service user";
        home = "/minecraft";
        createHome = true;
        isSystemUser = true;
        group = "minecraft";
      };
      users.groups.minecraft = {};

      systemd.sockets.minecraft-server = {
        bindsTo = ["minecraft-server.service"];
        socketConfig = {
          ListenFIFO = "/run/minecraft-server.stdin";
          SocketMode = "0660";
          SocketUser = "minecraft";
          SocketGroup = "minecraft";
          RemoveOnStop = true;
          FlushPending = true;
        };
      };

      systemd.services.minecraft-server = {
        enable = true;
        description = "Minecraft Server Service";
        wantedBy = ["multi-user.target"];
        requires = ["minecraft-server.socket"];
        after = ["network.target" "minecraft-server.socket"];

        serviceConfig = {
          ExecStart = "${pkgs.papermc}/bin/minecraft-server -Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
          ExecStop = "${stopScript} $MAINPID";
          Restart = "always";
          User = "minecraft";
          WorkingDirectory = "/minecraft";

          StandardInput = "socket";
          StandardOutput = "journal";
          StandardError = "journal";

          # Hardening
          CapabilityBoundingSet = [""];
          DeviceAllow = [""];
          LockPersonality = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
        };
        preStart = ''
          echo "eula=true" > eula.txt
        '';
      };
    };
  };
}
