# shell.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
  emacs = pkgs.callPackage ./emacs.nix { };
  clojure-layer = pkgs.callPackage ./layers/clojure.nix { };
  docker-layer = pkgs.callPackage ./layers/docker.nix { };
  shell-scripts-layer = pkgs.callPackage ./layers/shell-scripts.nix { };
  nixos-layer = pkgs.callPackage ./layers/nixos.nix { };
  #python-layer = pkgs.callPackage ./layers/python.nix { };
in pkgs.mkShell {
  packages = with pkgs; [
    emacs
    clojure-layer
    docker-layer
    shell-scripts-layer
    nixos-layer
    #python-layer
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  shellHook = ''
    echo "stand by..."
    ./spin-up.sh
    export SPACEMACSDIR=$(realpath "$XDG_CONFIG_HOME/spacemacs.d")
    echo "six ready"
  '';
}
