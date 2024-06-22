{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (import self.pins.nixGL { inherit pkgs; }) nixGLIntel;
in
{
  imports = [
    ../../modules/nixgl.nix
  ];
  nixGL.prefix = lib.getExe nixGLIntel;

  nix.package = pkgs.lix;
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") self.pins;
  nixpkgs = {
    config.allowBroken = true;
    config.allowUnfree = true;
    overlays = [ (_: prev: { neovim' = prev.wrapNeovim prev.neovim-unwrapped self.editors.neovim; }) ];
  };

  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    neovim'
    cached-nix-shell
    nh
    nixfmt-rfc-style
    nixGLIntel
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
    # vscode.enable = true;
    # vscode.package = config.lib.nixGL.wrap pkgs.vscodium-fhs;
  };
}
