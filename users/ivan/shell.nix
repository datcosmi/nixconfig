{pkgs, ...}: {
  programs.zsh = {
    shellAliases = {
      ll = "ls -lh";
      la = "eza --icons=always -a";
      ls = "eza --icons=always";
      lta = "eza --icons=always --tree";
      lsblk-model = "lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,MODEL | bat -l conf -p";

      cd = "z";

      inv = "nvim $(fzf -m --preview='bat --color=always {}')";

      shell = "source ~/.zshrc";

      nix-rebuild = "sudo nixos-rebuild switch --flake $HOME/nixconfig";
      # nix-rebuild = "sudo nixos-rebuild switch --flake $HOME/nixconfig#suavicrema";
      flake-check = "nix flake check $HOME/nixconfig";
      flake-update = "cd ~/nixconfig; nix flake update";
      update-nix = "cd ~/nixconfig; nix flake update; sudo nixos-rebuild switch --flake $HOME/nixconfig";
      # upgrade-nix = "cd ~/nixconfig; nix flake update; sudo nixos-rebuild switch --upgrade";

      list-gen = "nix profile history --profile /nix/var/nix/profiles/system";
      # gc-keep = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +6";
      del-gen = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations";
      gc = "sudo nix-collect-garbage";

      desk-names-global = "ls /run/current-system/sw/share/applications";
      desk-names-user = "ls /etc/profiles/per-user/$(id -n -u)/share/applications";
    };

    initContent = ''
      if [[ -o interactive ]]; then
        bindkey -v
        clear
        fastfetch
      fi
    '';
  };
}
