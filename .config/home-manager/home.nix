{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ ];
  nix = rec {
    registry = lib.pipe inputs [
      (lib.filterAttrs (_: lib.isType "flake"))
      (lib.mapAttrs (_: flake: { inherit flake; }))
    ];
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") registry;
    package = pkgs.lix;
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    cached-nix-shell
    pre-commit
    rlwrap
    shellcheck
    shfmt
    stylua
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
    neovim.enable = true;
    neovim.extraLuaConfig = builtins.readFile ./init.lua;
    neovim.extraPackages = with pkgs; [
      #haskell-language-server
      nixd
      #ocamlPackages.ocaml-lsp
      pyright
      #rust-analyzer
    ];
    neovim.plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      comment-nvim
      coq-artifacts
      coq_nvim
      coq-thirdparty
      nvim-autopairs
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];
    ripgrep.enable = true;
  };
}
