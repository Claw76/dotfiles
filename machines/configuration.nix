{ config, lib, pkgs, inputs, username, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
      acpi
      fd
      gcc
      git
      htop
      openssh
      openssl
      ripgrep
      tmux
      tree
      unzip
      usbutils
      wget
      xclip
      zip
    ];

  # Allow dynamic linking of packages I build
  programs.nix-ld.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";

  nix = {
    # package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  fonts.fonts = [ pkgs.corefonts ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  programs.ssh.askPassword = "";

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
  
  system.stateVersion = "23.05";
}