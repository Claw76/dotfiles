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

    packages.${system} = {
      prepare = with pkgs; writeShellApplication {
        name = "prepare-home";
        runtimeInputs = [ ];
        text = ''
          sudo groupadd uinput
          sudo usermod -aG input "$USER"
          sudo usermod -aG uinput "$USER"
          sudo touch /etc/udev/rules.d/kanata.rules
          echo "KERNEL=='uinput', MODE='0660', GROUP='uinput', OPTIONS+='static_node=uinput'" | \
          sudo tee -a /etc/udev/rules.d/kanata.rules > /dev/null
          sudo modprobe uinput
          rm -f "$HOME/.config/user-dirs.dirs"
          '';
      };

      post = with pkgs; writeShellApplication {
        name = "post-home";
        runtimeInputs = [ ];
        text = ''
          echo "/home/$USER/.nix-profile/bin/zsh" | \
          sudo tee -a /etc/shells > /dev/null
          chsh -s "$(which zsh)"
          '';
      };

      mkHome = with pkgs; writeShellApplication {
        name = "make-home";
        runtimeInputs = [ ];
        text = ''
          nix run github:Claw76/dotfiles#prepare
          nix run home-manager/release-23.05 -- switch -b backup --flake github:Claw76/dotfiles
          nix run github:Claw76/dotfiles#post
          echo "Run systemctl --user enable kanata.service and reboot"
          '';
      };

    };
  };
}
