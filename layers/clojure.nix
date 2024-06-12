# clojure.nix
{ pkgs ? import <nixpkgs> { } }:

let clojure-layer = [ pkgs.clojure pkgs.joker pkgs.clj-kondo ];
in clojure-layer

