inputs: {
  imports = [
    (import ./unfree.nix inputs)
    (import ./cockpit.nix inputs)
  ];
}
