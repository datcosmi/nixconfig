{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.features.shell.starship;
in {
  options.my.features.shell.starship.enable = lib.mkEnableOption "Enable starship shell";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        palette = "dream_lavender";

        format = lib.concatStrings [
          "[](lilac_mist)"
          "$os"
          "[](fg:lilac_mist bg:soft_lavender)"
          "$time"
          "[](fg:soft_lavender bg:violet_whisper)"
          "$directory"
          "[](fg:violet_whisper bg:orchid_haze)"
          "$git_branch"
          "$git_status"
          "[](fg:orchid_haze bg:dream_fog)"
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
          "[](fg:amethyst_glow)"
          "$line_break"
          "$character"
        ];

        palettes = {
          dream_lavender = {
            lilac_mist = "#cac7ff";
            soft_lavender = "#d7cdfe";
            violet_whisper = "#e4d3fc";
            orchid_haze = "#f1dafb";
            petal_light = "#fee0f9";

            amethyst_glow = "#a79cff";
            plum_ink = "#3f365f";
            dream_fog = "#f7e9fd";
          };
        };

        os = {
          disabled = false;
          style = "bg:lilac_mist fg:plum_ink";

          symbols = {
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "";
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
        };

        directory = {
          style = "fg:plum_ink bg:violet_whisper bold";
          format = "[  $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        git_branch = {
          symbol = " ";
          style = "bg:orchid_haze bold";
          format = "[[ $symbol $branch ](fg:plum_ink bg:orchid_haze bold)]($style)";
        };

        git_status = {
          style = "bg:orchid_haze bold";
          format = "[[($all_status$ahead_behind )](fg:plum_ink bg:orchid_haze)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:amethyst_glow";
          format = "[[ $symbol( $context) ](fg:petal_light bg:amethyst_glow)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:lilac_mist";
          format = "[[  $time ](fg:plum_ink bg:soft_lavender)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        php = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        kotlin = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        python = {
          symbol = "";
          style = "bg:dream_fog";
          format = "[[ $symbol($version) ](fg:amethyst_glow bg:dream_fog bold)]($style)";
        };

        character = {
          success_symbol = "[](bold fg:amethyst_glow)";
          error_symbol = "[](bold fg:#ff6b81)";
          vimcmd_symbol = "[](bold fg:amethyst_glow)";
          vimcmd_replace_one_symbol = "[](bold fg:lilac_mist)";
          vimcmd_replace_symbol = "[](bold fg:lilac_mist)";
          vimcmd_visual_symbol = "[](bold fg:soft_lavender)";
        };

        line_break.disabled = false;
      };
    };
  };
}
