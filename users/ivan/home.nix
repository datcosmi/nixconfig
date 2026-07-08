{pkgs, ...}: {
  imports = [
    ../../modules/home
    ./modules
  ];

  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "26.11";
  };

  programs.git = {
    settings = {
      user = {
        email = "cli.garcia@pm.me";
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
        browsers.librewolf.enable = false;
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
      niri.baseConfig = builtins.readFile ./modules/niri/config.kdl;
    };

    shell = {
      enable = true;
      # zsh.oh-my-zsh.enable = true;
    };

    dev.enable = true;
    terminal.kitty.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/jpg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/*" = "org.gnome.Loupe.desktop";

      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";

      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };

  home.file.".face".source = ./avatar.png;

  home.packages = with pkgs; [
    stow
    unzip
    qpwgraph
  ];
}
