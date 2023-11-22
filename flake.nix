{
  description = "My Personal NixOS Configuration Files";

  inputs =
  {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nur, home-manager, nixos-wsl, nix-index-database, flake-utils, nixgl, ... }:
    let
    username = "len";
  in
  {
    nixosConfigurations = (
	import ./machines { inherit (nixpkgs) lib; inherit inputs nixpkgs nixpkgs-unstable nur home-manager nixos-wsl nix-index-database flake-utils nixgl username; }
	);
  };
}
