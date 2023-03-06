{
  inputs = {
    #different nixpkgs channels
    stable.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    #automatic disk formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs = {
    stable,
    self,
    ...
  } @ inputs: {
    #your system
    nixosConfigurations."minecraft-server" = stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit self;};
      modules = [
        (import ./. inputs)
      ];
    };
    #formatter to keep things nice
    formatter.x86_64-linux = stable.legacyPackages.x86_64-linux.alejandra;
  };
}
