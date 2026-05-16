{
  lib,
  config,
  ...
}: let
  cfg = config.my.features.theme;
in
  lib.mkIf (cfg.palette == "catppuccin-mocha") {
    my.features.theme.colors = {
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };

    my.features.theme = {
      wallpaper = ../wallpapers/blue-landscape-cat.png;
      rofi-bg = ../wallpapers/rofi-bg.jpg;
    };

    catppuccin = {
      bat = {
        enable = true;
        flavor = "mocha";
      };

      lazygit = {
        enable = true;
        flavor = "mocha";
        accent = "pink";
      };

      fzf = {
        enable = true;
        flavor = "mocha";
      };

      eza = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
      };

      wleave = {
        enable = true;
        flavor = "mocha";
        accent = "pink";
        iconStyle = "wleave";
      };

      btop = {
        enable = true;
        flavor = "mocha";
      };

      yazi = {
        enable = true;
        flavor = "mocha";
        accent = "pink";
      };

      kitty = {
        enable = true;
        flavor = "mocha";
      };

      ghostty = {
        enable = true;
        flavor = "mocha";
      };

      swaync = {
        enable = true;
        flavor = "mocha";
        font = "CommitMono Nerd Font";
      };

      librewolf = {
        enable = true;
        flavor = "mocha";
        accent = "pink";
      };
    };
  }
