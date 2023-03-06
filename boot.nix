_: {pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
    kernelModules = ["kvm-amd"];
    blacklistedKernelModules = ["pcspkr"];
    kernelParams = ["net.ifnames=0"];
  };
}
