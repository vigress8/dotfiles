{ lib, pkgs, ... }:
{
  imports = [ ];
  nix.package = pkgs.lix;

  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    neovim'
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
    bat.enable = true;
    bat.config.map-syntax = [ "*.pacscript:Bash" ];
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    eza.enable = true;
    eza.icons = true;
    fd.enable = true;
    ripgrep.enable = true;
  };
}
