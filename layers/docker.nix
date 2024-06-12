# docker.nix
{ pkgs ? import <nixpkgs> { } }:

let
  docker-layer =
    [ pkgs.shellcheck pkgs.hadolint pkgs.dockerfile-language-server-nodejs ];
in docker-layer
