{ config, pkgs, lib, ... }:
let
	media = "${config.home.homeDirectory}/Media";
	other = "${config.home.homeDirectory}/Other";
in {
	home.username = "len";
	home.homeDirectory = "/home/len";
	home.stateVersion = "23.05";

	# let home-manager manage itself
	programs.home-manager.enable = true;
	# should improve experience on non-nixos distros 
	targets.genericLinux.enable = true;

	xdg.enable = true;
	xdg.userDirs = {
		enable = true;
		createDirectories = true;
		music = "${media}";
		pictures = "${media}";
		videos = "${media}";
		publicShare = "${other}";
		templates = "${other}";
	};
	# As GUI apps installed through nix+hm have problems anyway, do not add this yet 
	# xdg.mime.enable = true;
	# xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

	fonts.fontconfig.enable = true;

	home.packages = with pkgs; [
		# github:loichyan/nerdfix flake to fix Nerd Font icon problems
		# override nerdfonts to only download JetBrainsMono
		(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
		# alacritty
		# vscode
		kanata
		sshpass 
		lazygit
		tmux
		vim
	];

	systemd.user.services = {
		kanata = {
			Unit = {
				Description = "Kanata keyboard remapper";
				Documentation = [ "https://github.com/jtroo/kanata" ];
			};
			Service = {
				Environment=["DISPLAY=:0"];
				Type="simple";
				ExecStart="/home/len/.nix-profile/bin/kanata --cfg /home/len/.config/kanata.kbd";
				Restart="no";
			};
			Install = {
				WantedBy=["default.target"];
			};
		};
	};

	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
			plugins = with pkgs.vimPlugins; [
				nvim-treesitter.withAllGrammars
				onedark-nvim
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
			shellAliases = {
				"home-manager-switch" = "home-manager switch --flake ~/Projects/dotfiles";
			};
		};
		fzf = {
			enable = true;
			enableZshIntegration = true;
		};
		tmux = {
			enable = true;
			mouse = true;
			clock24 = true;
		};
		# import starship.nix and pass "lib" to it
		starship = import ./starship.nix lib;
	};

	# home-managers alacritty config does not work for the flatpak
	xdg.configFile."alacritty.yml".source = ./alacritty.yml;
	xdg.configFile."kanata.kbd".source = ./kanata.kbd;
	# xdg.configFile."systemd/user/kanata.service".source = ./kanata.service;
	xdg.configFile."nvim".source = ./nvim;

	home.sessionVariables = {
		LESS = "$LESS -R -Q"; # quiet less
	};

	home.shellAliases = {
		hms = "home-manager switch --flake ~/Projects/dotfiles";
	};
}
