{
  lib,
  pkgs,
  pins,
  ...
}:
let
  inherit (import pins.nixGL { inherit pkgs; }) nixGLIntel;
in
{
  imports = [
    (builtins.fetchurl {
      url = "https://github.com/Smona/home-manager/raw/79a6027c4b4d1ce12e6a9e93b87c252aa1041c48/modules/misc/nixgl.nix";
      sha256 = "14dkxynwizaabr58h409hv46gjg5v8y4pr6ww0lx62b58yr900hl";
    })
  ];
  nixGL.prefix = lib.getExe nixGLIntel;

  nix.package = pkgs.lix;
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") pins;

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
    vscode.enable = true;
    vscode.package = lib.nixGL.wrap pkgs.vscodium-fhs;
  };
}
