{ config, pkgs, ... }:
{
  imports = [ ./vscode.nix ];
  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    cached-nix-shell
    rlwrap
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
