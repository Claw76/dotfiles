{ lib, inputs, nixpkgs, nixpkgs-unstable, nur, home-manager, nixos-wsl, nix-index-database, flake-utils, nixgl, username, ... }:

let
system = "x86_64-linux";
lib = nixpkgs.lib;

nixpkgsWithOverlays = with inputs; rec 
{
  config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # FIXME: add any insecure packages you absolutely need here
      # "python-2.7.18.6" # needed for core-utils
    ];
  };
  overlays = [
    nur.overlay
    nixgl.overlay
      (_final: prev: {
      # this allows us to reference pkgs.unstable
       unstable = import nixpkgs-unstable {
       inherit (prev) system;
       inherit config;
       };
       })
  ];
};

configurationDefaults = {
  nixpkgs = nixpkgsWithOverlays;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;	  
};

in
{
  # WSL
  nixos = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs username nix-index-database; };
    modules = [
	configurationDefaults
	nixos-wsl.nixosModules.wsl
	./wsl
	./configuration.nix
	home-manager.nixosModules.home-manager {
	  home-manager.extraSpecialArgs = { inherit username nix-index-database; };
	  home-manager.users.${username}.imports = [(import ./home.nix)] ++ [(import ./wsl/home.nix)];
	}
    ];
  };
}
