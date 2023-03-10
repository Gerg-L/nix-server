_: {pkgs, ...}: {
  #grab some packages
  environment = {
    systemPackages = [
      pkgs.page
      pkgs.exa
      pkgs.neovim
      pkgs.neofetch
    ];
    binsh = "${pkgs.dash}/bin/dash"; #use dash for speed
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "page";
      SYSTEMD_PAGERSECURE = "true";
    };
    shellAliases = {
      #paste link trick
      pastebin = "curl -F 'clbin=<-' https://clbin.com";
      #nix stuff
      nix-update = "nix flake update /etc/nixos/";
      nix-switch = "nixos-rebuild switch";
      nix-boot = "nixos-rebuild boot";
      nix-clean = "nix-collect-garbage -d";
      nix-gc-force = "rm /nix/var/nix/gcroots/auto/*";
      nix-gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";
      #vim stuff
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      #exa is 1 too many letters
      ls = "exa";
      l = "exa -lbF --git";
      ll = "exa -lbGF --git";
      llm = "exa -lbGd --git --sort=modified";
      la = "exa -lbhHigUmuSa --time-style=long-iso --git --color-scale";
      lx = "exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale";
      lS = "exa -1";
      lt = "exa --tree --level=2";
    };
    interactiveShellInit = "neofetch";
  };

  #zsh stuff
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [pkgs.zsh];
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 1000;
      histFile = "$HOME/.cache/zsh_history";
    };
    #starship
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$sudo$cmd_duration \n $directory$git_branch$character";
        character = {
          success_symbol = "[ ](#9ece6a bold)";
          error_symbol = "[ ](#db4b4b bold)";
        };
        directory = {
          read_only = " ";
        };
        git_branch = {
          style = "bold red";
        };
        sudo = {
          format = "[ ](#7aa2f7)";
          disabled = false;
        };
        cmd_duration = {
          min_time = 5000;
          style = "bold #9ece6a";
        };
      };
    };
  };
}
