{ config, pkgs, lib, username, nix-index-database, ... }:
{
	programs.home-manager.enable = true; # home-manager self management

		home.packages = with pkgs; [
		kanata
			sshpass 
			lazygit
			tmux
			vim
			zoxide
		];

	programs = {
		direnv.nix-direnv.enable = true;		

# import starship.nix and pass "lib" to it
		starship = import ./starship.nix lib;		

		neovim = {
			enable = true;
			defaultEditor = true;
			plugins = with pkgs.vimPlugins; [
				nvim-treesitter.withAllGrammars # limit grammars!
					onedark-nvim
			];
		};
		git = {
			enable = true;
			userEmail = "claw76@projectfoo.dev";
			userName = "Claw76";
		};
		tmux = {
			enable = true;
			mouse = true;
			clock24 = true;
		};
		zsh = {
			enable = true;
			dotDir = ".config/zsh";
			enableAutosuggestions = true;
			enableCompletion = true;
			history.path = "${config.xdg.configHome}/zsh/zsh_history";
			history.expireDuplicatesFirst = true;
			history.ignoreDups = true;
			history.ignoreSpace = true;
			historySubstringSearch.enable = true;

			plugins = [
			{
				name = "fast-syntax-highlighting";
				src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
			}
			{
				name = "zsh-nix-shell";
				file = "nix-shell.plugin.zsh";
				src = pkgs.fetchFromGitHub {
					owner = "chisui";
					repo = "zsh-nix-shell";
					rev = "v0.5.0";
					sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
				};
			}
			];

			initExtra = ''
				WORDCHARS='*?[]~=&;!#$%^(){}<>'

# fixes duplication of commands when using tab-completion
				export LANG=C.UTF-8
				'';
		};		
	};

	xdg.configFile."nvim".source = ./nvim;

	home.sessionVariables = {
		LESS = "$LESS -R -Q"; # quiet less
	};

	home.shellAliases = {
# hms = "echo 'warning: This is using the --impure flag!' && home-manager switch --flake ~/Projects/dotfiles --impure";
	};
}
