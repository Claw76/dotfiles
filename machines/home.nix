{ config, lib, pkgs, nix-index-database, username, ... }:

{
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  programs.home-manager.enable = true;
  	
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  
  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = true;
  programs.nix-index-database.comma.enable = true;
  
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  # services.lorri.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    file.".config/nixpkgs/config.nix" = {
      text = ''
        { allowUnfree = true; }
      '';
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}