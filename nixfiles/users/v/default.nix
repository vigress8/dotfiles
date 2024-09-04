{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  imports = [ /* ../../modules/neovim */ ];

  nix = {
    package = pkgs.lix;
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v}") flakeInputs;
    registry = builtins.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
  };

  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    cached-nix-shell
    nh
    nixd
    nixfmt-rfc-style
    npins
    pre-commit
    rlwrap
    shellcheck
    shfmt
    yt-dlp
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.shellAliases = {
    g = "git";
    "..." = "cd ../..";
    "...." = "cd ../../..";
  };

  programs = {
    home-manager.enable = true;
    bat = {
      enable = true;
      config.map-syntax = [ "*.pacscript:Bash" ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      icons = true;
    };
    fd.enable = true;
    fish = {
      enable = true;
      shellInit = ''
        umask u=rwx,go=rx
      '';
      plugins = [
        {
          name = "foreign-env";
          src = inputs.foreign-env.outPath;
        }
      ];
    };
    jujutsu.enable = true;
    neovim.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    oh-my-posh = {
      enable = true;
      settings = lib.importJSON "${pkgs.oh-my-posh}/share/oh-my-posh/themes/catppuccin_latte.omp.json";
    };
    ripgrep.enable = true;
  };
}
