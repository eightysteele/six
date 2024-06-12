# shell-scripts.nix
{ pkgs ? import <nixpkgs> { } }:

let
  shell-scripts-layer =
    [ pkgs.nodePackages_latest.bash-language-server pkgs.bashate pkgs.shfmt ];
in shell-scripts-layer

