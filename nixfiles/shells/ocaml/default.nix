{ pkgs, ... }:
pkgs.mkShellNoCC {
  packages = with pkgs; [
    ocaml
    ocamlformat
    #ocamlPackages.core
    ocamlPackages.findlib
    ocamlPackages.ocaml-lsp
    ocamlPackages.utop
  ];
}
