{
  description = "Home Manager configuration of len";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-23.05";
      # config.allowUnfree = true;
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."len" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

      packages.${system}.createHome = pkgs.writeShellApplication {
        name = "create-home";
        runtimeInputs = [ pkgs.cowsay ];
        text = ''
          # nix run github:Claw76/dotfiles#homeConfigurations.len.activationPackage
          groupadd uinput
          usermod -aG input "$USER"
          usermod -aG uinput "$USER"
          touch /etc/udev/rules.d/kanata.rules
          echo "KERNEL=='uinput', MODE='0660', GROUP='uinput', OPTIONS+='static_node=uinput'" | \
          sudo tee -a /etc/udev/rules.d/kanata.rules > /dev/null
          modprobe uinput
          systemctl --user enable kanata.service
        '';
      };
    };
}
