# python.nix
{ pkgs ? import <nixpkgs> { } }:

let
  python-layer =
    [ pkgs.python312Packages.nose pkgs.python312Packages.python-lsp-server ];
in python-layer

