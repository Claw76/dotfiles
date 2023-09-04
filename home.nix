{ config, pkgs, lib, ... }:
let
	media = "${config.home.homeDirectory}/Media";
	other = "${config.home.homeDirectory}/Other";
	nixgl = pkgs.nixgl;
	nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
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
	home.username = "len";
	home.homeDirectory = "/home/len";
	home.stateVersion = "23.05";

	programs.home-manager.enable = true; # home-manager self management
	targets.genericLinux.enable = true; # improve experience on non-nixos distros

	# TODO: On home activation update x desktop application cache
  # TODO: "Hide" nixgl behind auto-detection of --impure flag

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

	xdg.mime.enable = true;
	xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

	fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
		# github:loichyan/nerdfix flake to fix Nerd Font icon problems
		# override nerdfonts to only download JetBrainsMono
		(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
		kanata
		sshpass 
		lazygit
		tmux
		vim
		nixgl.auto.nixGLDefault
		(nixGLWrap alacritty)
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
				ExecStart="${config.home.homeDirectory}/.nix-profile/bin/kanata --cfg ${config.home.homeDirectory}/.config/kanata.kbd";
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
	xdg.configFile."nvim".source = ./nvim;

	home.sessionVariables = {
		LESS = "$LESS -R -Q"; # quiet less
	};

	home.shellAliases = {
		hms = "echo 'warning: This is using the --impure flag!' && home-manager switch --flake ~/Projects/dotfiles --impure";
	};
}
