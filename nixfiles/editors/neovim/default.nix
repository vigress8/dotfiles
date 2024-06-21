{ pkgs, ... }:
{
  configure = {
    customRC = ''
      source ${./init.lua}
    '';
    packages.all.start = with pkgs.vimPlugins; [
      catppuccin-nvim
      comment-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];
  };
}
