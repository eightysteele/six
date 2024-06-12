# nixos.nix
{ pkgs ? import <nixpkgs> { } }:

let
  rnix-lsp = builtins.fetchTarball {
    url = "https://github.com/nix-community/rnix-lsp/archive/master.tar.gz";
    sha256 = "197s5qi0yqxl84axziq3pcpf5qa9za82siv3ap6v3rcjmndk8jqp";
  };

  nixos-layer = [ pkgs.nixfmt rnix-lsp ];
in nixos-layer

