lib:
# This file contains one function that needs "lib" passed to it
{
  # starship config
  enable = true;
  enableZshIntegration = true;
  settings = {
    add_newline = true;
    format = lib.concatStrings [
      "[╭╴](238)$env_var"
      "$sudo"
      "$username"
      "$hostname"
      "$nix_shell"
      "$directory"
      "[ ]($style)"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_metrics"
      "$git_status"
      "$nodejs"
      "$java"
      "$rust"
      "$python"
      "$fill"
      "$battery"
      "$cmd_duration"
      "$all"
      "[╰─](238)$character"
    ];
    character = {
      success_symbol = "[󰁔](238)";
      error_symbol = "[Σ](bold red)";
    };
    fill = {
      symbol = " ";
    };
    sudo = {
      format = "$symbol";
      disabled = false;
    };
    username = {
      style_user = "069 bold";
      style_root = "black bold";
      format = "[$user]($style)";
      disabled = false;
      show_always = true;
    };
    hostname = {
      ssh_only = false;
      format = "[@](238)[$hostname]($style)[$ssh_symbol](green) ";
      ssh_symbol = "󰖟 ";
      style = "57 bold";
    };
    directory = {
      truncation_symbol = "…/";
      home_symbol = "󰋞 ~";
      read_only_style = "197";
      read_only = "  ";
      format = "[$path]($style)[$read_only]($read_only_style)";
    };
    git_branch = {
      symbol = "󰊢 ";
      format = "\\[[$symbol$branch]($style)\\]";
      truncation_length = 6;
      truncation_symbol = "…/";
      style = "bold green";
    };
    git_status = {
      format = "[$all_status$ahead_behind]($style)";
      conflicted = "🏳";
      up_to_date = "[ ](green)";
      untracked = "[ ](yellow)";
      ahead = "⇡$count";
      diverged = "⇕⇡$ahead_count⇣$behind_count";
      behind = "⇣$count";
      stashed = "󰏗 ";
      modified = "[ ](yellow)";
      staged = "[++\\($count\\)](green)";
      renamed = "[󰖷 ](orange)";
      deleted = "[ ](orange)";
    };
    cmd_duration = {
      min_time = 5000; # in millis
      format = "t=[$duration]($style)";
    };

    nix_shell = {
      symbol = "󱄅 ";
      format = "[$symbol(\\($name\\) )]($style)";
      heuristic = true;
    };

    nodejs = {
      format = "\\[[$symbol($version)]($style)\\]";
    };

    java = {
      format = "\\[[$symbol($version)]($style)\\]";
    };

    rust = {
      format = "\\[[$symbol($version)]($style)\\]";
    };

    python = {
      format = "\\[[$symbol($version)]($style)\\][\\($virtualenv\\)](238)";
      python_binary = "python3";
      symbol = "󰌠 ";
    };

    package = {
      format = "[$symbol$version]($style)";
      symbol = "📦";
      version_format = "v$major.$minor";
    };

    # [battery]
    # [[battery.display]]
    # threshold = 20
    # style = "bold red"
    # discharging_symbol = "💀"
    # charging_symbol = "⚡️"

    # [[battery.display]]
    # threshold = 50
    # style = "bold #FF7700"
    # discharging_symbol = "󰂃"

    # [[battery.display]]
    # threshold = 75
    # style = "bold green"

    # [[battery.display]]
    # threshold = 90
    # style = "bold #0000FF"
  };
}
