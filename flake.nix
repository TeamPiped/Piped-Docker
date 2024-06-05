{
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; };

  outputs = { nixpkgs, ... }@inputs: {
    nixosModules = { default = import ./nix; };
  };
}
