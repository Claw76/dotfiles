{
  pkgs,
  lib,
  username,
  ...
}: {
  networking.hostName = "nixsl";

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = [
    (import ./win32yank.nix {inherit pkgs;})
  ];

  system.stateVersion = "23.05";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294
  # systemd.user = {
  #   paths.vscode-remote-workaround = {
  #     wantedBy = ["default.target"];
  #     pathConfig.PathChanged = "%h/.vscode-server/bin";
  #   };
  #   services.vscode-remote-workaround.script = ''
  #     for i in ~/.vscode-server/bin/*; do
  #       echo "Fixing vscode-server in $i..."
  #       ln -sf ${pkgs.nodejs_18}/bin/node $i/node
  #     done
  #   '';
  # };

  nix = {
    settings = {
      trusted-users = [username];
      accept-flake-config = true;
      auto-optimise-store = true;
    };

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
