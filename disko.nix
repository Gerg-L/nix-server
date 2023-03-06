{disko, ...}: {
  imports = [
    disko.nixosModules.disko
  ];
  disk = {
    #TODO make sure it's a nvme
    nvme0n1 = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            #make boot partition
            name = "BOOT";
            type = "partition";
            start = "1MiB";
            end = "1000";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            #make root parition
            name = "ROOT";
            type = "partition";
            start = "1000";
            end = "100%";
            part-type = "primary";
            bootable = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
        ];
      };
    };
  };
}
