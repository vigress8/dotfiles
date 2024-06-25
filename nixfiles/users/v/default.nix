{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ];

  nix = {
    package = pkgs.lix;
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v}") inputs;
    registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
  };

  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    cached-nix-shell
    nh
    nixfmt-rfc-style
    npins
    pre-commit
    rlwrap
    shellcheck
    shfmt
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
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
      plugins = [
        {
          name = "foreign-env";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-foreign-env";
            rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
            hash = "sha256-4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
          };
        }
      ];
    };
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    oh-my-posh = {
      enable = true;
      settings = lib.importJSON "${pkgs.oh-my-posh}/share/oh-my-posh/themes/catppuccin_latte.omp.json";
    };
    ripgrep.enable = true;
  };
}
