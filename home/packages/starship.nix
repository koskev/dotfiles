{
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      format = lib.concatStrings [
        "$shlvl"
        "$username"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state" # Merging etc
        "$git_metrics"
        "$git_status"
        "$nix_shell"

        # Right
        "$fill"
        "$time"
        "$kubernetes"
        "$line_break"
        # Command line
        "$status"
        "$character"
      ];
      line_break = {
        disabled = false;
      };
      kubernetes = {
        disabled = false;
        format = ''[\($symbol$cluster\)]($style)'';
        style = "cyan";
        contexts = [
          {
            context_pattern = ".*(prod|live)";
            style = "red bold";
          }
          {
            context_pattern = ".*(uat|pre)";
            style = "orange bold";
          }
          {
            context_pattern = ".*sit";
            style = "yellow";
          }
          {
            context_pattern = ".*int";
            style = "green";
          }
        ];
      };
      fill = {
        symbol = " ";
      };
      status = {
        disabled = false;
      };

      git_branch = {
        format = ''\[[$branch]($style)\]'';
      };

      directory = {
        truncate_to_repo = false;
      };

      nix_shell = {
        # XXX: This does not really work on NixOS
        heuristic = false;
      };

      shlvl = {
        disabled = false;
        # Alacritty starts at 2 (might be due to no login manager?)
        threshold = 3;
      };

      time = {
        disabled = false;
      };

    };
  };
}
