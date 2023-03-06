_: {pkgs, ...}: {
  boot = {
    #grab latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    #clean tmp on reboot
    cleanTmpDir = true;
    #use systemd-boot
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      #don't wait to boot
      timeout = 0;
    };
    #TODO make sure this is enough kernel modules
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci"];
    #allow virtualization
    kernelModules = ["kvm-amd"];
    #don't beep
    blacklistedKernelModules = ["pcspkr"];
    #normal network interface names
    kernelParams = ["net.ifnames=0"];
  };
}
