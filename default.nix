inputs: {
  imports = [
    (import ./boot.nix inputs)
    (import ./configuration.nix inputs)
    (import ./containers inputs)
    (import ./disko.nix inputs)
    (import ./modules inputs)
    (import ./nix.nix inputs)
  ];
}
