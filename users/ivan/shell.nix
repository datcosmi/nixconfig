{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    defaultKeymap = "viins";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";

    shellAliases = {
      ll = "ls -l";
      la = "eza --icons=always -a";
      ls = "eza --icons=always";
      lst = "eza --icons=always --tree";
      lsblk-model = "lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,MODEL | bat -l conf -p";

      cd = "z";

      inv = "nvim $(fzf -m --preview='bat --color=always {}')";

      shell = "source ~/.zshrc";

      nix-rebuild = "sudo nixos-rebuild switch --flake $HOME/nixos-conf";
      # nix-rebuild = "sudo nixos-rebuild switch --flake $HOME/nixos-conf#suavicrema";
      flake-check = "nix flake check $HOME/nixos-conf";
      flake-update = "cd ~/nixos-conf; nix flake update";
      update-nix = "cd ~/nixos-conf; nix flake update; sudo nixos-rebuild switch --flake $HOME/nixos-conf";
      # upgrade-nix = "cd ~/nixos-conf; nix flake update; sudo nixos-rebuild switch --upgrade";

      list-gen = "nix profile history --profile /nix/var/nix/profiles/system";
      # gc-keep = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +6";
      del-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
      gc = "sudo nix-collect-garbage";

      desk-names-global = "ls /run/current-system/sw/share/applications";
      desk-names-user = "ls /etc/profiles/per-user/$(id -n -u)/share/applications";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "dirhistory"
        "history"
        "ssh-agent"
      ];
      theme = "robbyrussell";
    };

    initContent = ''
      if [[ -o interactive ]]; then
        bindkey -v
        clear
        fastfetch
      fi
    '';
  };

  programs.zoxide.enable = true;
  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.bash.enable = true;
  programs.ripgrep.enable = true;
  programs.jq.enable = true;
  programs.fd.enable = true;

  programs.tealdeer = {
    enable = true;

    settings = {
      settings = {
        auto_update = true;
      };
    };
  };
}
