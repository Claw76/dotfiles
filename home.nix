{ config, pkgs, lib, ... }:

{
	home.username = "len";
	home.homeDirectory = "/home/len";
	home.stateVersion = "23.05";
	# let home-manager manage itself
	programs.home-manager.enable = true;

	xdg.enable = true;
	# xdg.desktopEntries = {
	#	alacritty = {
	#		name = "Alacritty";
	#		genericName = "Terminal";
	#		exec = "alacritty";
	#		terminal = false;
	#	};
	# };

	fonts.fontconfig.enable = true;

	home.packages = with pkgs; [
		# github:loichyan/nerdfix flake to fix Nerd Font icon problems
		# override nerdfonts to only download JetBrainsMono
		(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
		# alacritty
		# vscode
		kanata
		sshpass 
	];

	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
			plugins = with pkgs.vimPlugins; [
				nvim-treesitter.withAllGrammars
			];
		};
		git = {
			enable = true;
			userEmail = "claw76@projectfoo.dev";
			userName = "Claw76";
		};
		zsh = {
			enable = true;
			dotDir = ".config/zsh";
			history.path = "${config.xdg.configHome}/zsh/zsh_history";
			oh-my-zsh.enable = true;
		};
		# import starship.nix and pass "lib" to it
		starship = import ./starship.nix lib;
	};

	# home-managers alacritty config does not work for the flatpak
	xdg.configFile."alacritty.yml".source = ./alacritty.yml;
	xdg.configFile."kanata.kbd".source = ./kanata.kbd;
	xdg.configFile."systemd/user/kanata.service".source = ./kanata.service;
	

	home.sessionVariables = {
		LESS = "$LESS -R -Q"; # quiet less
	};
}
