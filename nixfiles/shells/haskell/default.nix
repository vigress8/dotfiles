{ pkgs, lib', ... }:
let
  neovim' = lib'.extendNeovim (old: {
    configure.customRC =
      old.configure.customRC
      + ''
        source ${./init.lua}
      '';
  });
in
assert builtins.trace neovim' true;
pkgs.mkShellNoCC {
  packages =
    [ neovim' ]
    ++ (with pkgs.haskellPackages; [
      (ghcWithPackages (p: [ p.aeson ]))
      Cabal
      fourmolu
      ghcid
      haskell-language-server
      hlint
    ]);
}
