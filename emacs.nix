# emacs.nix
{ pkgs ? import <nixpkgs> { } }:

let
  emacs = pkgs.emacs.overrideAttrs (oldAttrs: rec {
    version = "29.3";
    src = pkgs.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "emacs-29.3";
      sha256 = "1vahi87r1al125bqk8klx5fgi9syvnhbv35yjr3vyafyv3apq8z3";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ]
      ++ [ pkgs.pkg-config ];

    buildInputs = oldAttrs.buildInputs or [ ]
      ++ [ pkgs.imagemagick.dev pkgs.gtk3.dev pkgs.webkitgtk.dev ];

    configureFlags = oldAttrs.configureFlags ++ [
      "--with-xwidgets"
      "--with-x"
      "--with-x-toolkit=gtk3"
      "--with-imagemagick"
      "--with-json"
      "--with-native-compilation=yes"
      "--with-mailutils"
    ];

    buildPhase = ''
      make -j$(nproc)
    '';

    patches = [ ];
  });
in emacs

