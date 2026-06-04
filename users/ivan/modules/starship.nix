{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.starship;
in {
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enableZshIntegration = true;
      enableFishIntegration = true;

      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        palette = "dream_lavender";

        format = lib.concatStrings [
          # Top line
          "[╭─](lavender_edge)"
          "[](purple_night)"
          "$os"
          "[](fg:purple_night bg:lilac_mist)"
          "$username"
          "[](fg:lilac_mist bg:soft_lavender)"
          "$time"
          "[](fg:soft_lavender bg:violet_whisper)"
          "$directory"
          "[](fg:violet_whisper bg:orchid_haze)"
          "$git_branch"
          "$git_status"
          "[](fg:orchid_haze bg:dream_fog)"
          "$nix_shell"
          "$c"
          "$rust"
          "$golang"
          "$nodejs"
          "$php"
          "$java"
          "$kotlin"
          "$haskell"
          "$python"
          "[](fg:dream_fog bg:amethyst_glow)"
          "$docker_context"
          "$cmd_duration"
          "[](fg:amethyst_glow)"
          "$line_break"

          # Bottom line
          "[╰─](lavender_edge)"
          "$character"
        ];

        palettes = {
          dream_lavender = {
            purple_night = "#BAAEFC";
            lilac_mist = "#c8bfff";
            soft_lavender = "#d7cdfe";
            violet_whisper = "#e6d7ff";
            orchid_haze = "#f0ddff";
            petal_light = "#fdf4ff";

            amethyst_glow = "#9f8cff";
            lavender_edge = "#7f6db3";
            moon_shadow = "#2b253d";
            plum_ink = "#3f365f";
            dream_fog = "#f8efff";

            rose_blush = "#ffb3c7";
            mint_glow = "#b8ffd6";
            golden_haze = "#ffe59e";
            cyber_blue = "#8be9fd";
            sapphire_tint = "#6EB2FF";
          };
        };

        os = {
          disabled = false;
          style = "bg:purple_night fg:moon_shadow bold";

          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            NixOS = "󱄅 ";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
          };

          format = "[ $symbol ]($style)";
        };

        username = {
          show_always = true;
          style_user = "bg:lilac_mist fg:moon_shadow bold";
          style_root = "bg:lilac_mist fg:rose_blush bold";
          format = "[  $user ]($style)";
        };

        directory = {
          style = "fg:moon_shadow bg:violet_whisper bold";
          format = "[  $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          home_symbol = "~";

          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = "󰝚 ";
            Pictures = " ";
            Projects = "󰲋 ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:orchid_haze";
          format = "[[ $symbol $branch ](fg:moon_shadow bg:orchid_haze bold)]($style)";
        };

        git_status = {
          style = "bg:orchid_haze";
          format = "[[($all_status$ahead_behind )](fg:amethyst_glow bg:orchid_haze bold)]($style)";
          conflicted = "󰞇 ";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          untracked = "?\${count}";
          stashed = "󰏗 ";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          deleted = "✘\${count}";
        };

        nix_shell = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol$name ](fg:cyber_blue bg:dream_fog bold)]($style)";

          heuristic = false;

          impure_msg = "[impure](bold fg:golden_haze)";
          pure_msg = "[pure](bold fg:mint_glow)";
        };

        docker_context = {
          symbol = "";
          style = "bg:amethyst_glow";
          format = "[[ $symbol $context ](fg:petal_light bg:amethyst_glow bold)]($style)";
        };

        cmd_duration = {
          min_time = 500;
          style = "bg:amethyst_glow";
          format = "[[  $duration ](fg:petal_light bg:amethyst_glow bold)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:soft_lavender";
          format = "[[  $time ](fg:moon_shadow bg:soft_lavender)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        rust = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        golang = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        nodejs = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        php = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        kotlin = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        haskell = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        python = {
          symbol = " ";
          style = "bg:dream_fog";
          python_binary = ["./venv/bin/python" "python" "python3"];
          format = "[[ $symbol\${pyenv_prefix}(\${version})(\\($virtualenv\\)) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        character = {
          success_symbol = "[❯](bold fg:mint_glow)";
          error_symbol = "[❯](bold fg:rose_blush)";
          vimcmd_symbol = "[❮](bold fg:amethyst_glow)";
          vimcmd_replace_one_symbol = "[❮](bold fg:golden_haze)";
          vimcmd_replace_symbol = "[❮](bold fg:golden_haze)";
          vimcmd_visual_symbol = "[❮](bold fg:cyber_blue)";
        };

        line_break = {
          disabled = false;
        };
      };
    };
  };
}
