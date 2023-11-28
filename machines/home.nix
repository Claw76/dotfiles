{
  config,
  lib,
  pkgs,
  nix-index-database,
  username,
  ...
}: let
  nixgl = pkgs.nixgl;
  nixGLWrap = pkg:
    pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "exec ${lib.getExe nixgl.auto.nixGLDefault} $bin \"\$@\"" > $wrapped_bin
      chmod +x $wrapped_bin
      done
    '';
in {
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

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
    nixgl.auto.nixGLDefault
    (nixGLWrap alacritty)
    alejandra
    nil
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";

    file.".config/nixpkgs/config.nix" = {
      text = ''
        { allowUnfree = true; }
      '';
    };

    # sessionPath = [
    #   "$HOME/.local/bin"
    # ];
  };
}
