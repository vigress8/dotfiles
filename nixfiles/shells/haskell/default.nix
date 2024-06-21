{ pkgs, ... }:
pkgs.mkShellNoCC {
  packages =
    [ ]
    ++ (with pkgs.haskellPackages; [
      (ghcWithPackages (p: [ p.aeson ]))
      Cabal
      fourmolu
      ghcid
      haskell-language-server
      hlint
    ]);
}
