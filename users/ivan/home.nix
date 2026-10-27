{
  inputs,
  config,
  pkgs,
  ...
}: {
  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "26.11";
  };

  programs.git = {
    settings = {
      user = {
        email = "dev@cligarcia.com";
        name = "Iván García";
      };
    };
  };

  my.features = {
    theme = {
      dark = true;
      palette = "catppuccin-mocha";
      gtk = "adwaita";
      cursor = "bibata-ice";
    };

    desktop = {
      apps = {
        enable = true;
        browsers.zen-browser = {
          hardening.enable = true;
          makeDefault = true;
        };
        music.tidal.enable = false;
      };

      ui = {
        waybar.enable = false;
        swaync.enable = false;
        swayosd.enable = false;
        wleave.enable = false;
      };

      userDirectories.enable = true;
      wallpaper.awww.enable = false;
      custom.niriLockSuspend.enable = false;
      shell.noctalia.enable = true;
      niri.baseConfig = import ./modules/_niri/base-settings.nix;
    };

    shell = {
      enable = true;
    };

    dev.enable = true;
    terminal.kitty.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = with pkgs; [
      loupe
      zathura
      celluloid
    ];
  };

  home.file.".face".source = ./avatar.png;

  home.packages = with pkgs; [
    stow
    unzip
    zip
    yt-dlp
    celluloid
    stylua
  ];
}
