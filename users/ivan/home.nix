{pkgs, ...}: {
  imports = [
    ../../modules/home
    ./shell.nix
  ];

  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";
    stateVersion = "26.05";
  };

  programs.git = {
    settings = {
      user = {
        email = "garcia.cli@pm.me";
        name = "Iván García";
      };
    };
  };

  my.features = {
    theme = {
      palette = "catppuccin-mocha";
      gtk = "adwaita";
      cursor = "bibata-ice";
    };

    desktop.apps.enable = true;
    dev.enable = true;
    shell.enable = true;
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

  home.packages = with pkgs; [
    stow
    exfatprogs
    unzip
  ];
}
