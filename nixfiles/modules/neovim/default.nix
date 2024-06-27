{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.neovim;
in
lib.mkIf cfg.enable {
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };
  home.shellAliases = {
    v = "nvim";
  };
  programs.neovim = {
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      comment-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];
  };
}
