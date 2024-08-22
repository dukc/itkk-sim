# Tämä tiedosto on itseäni varten. Minulla on NixOS, jolla ei voi noin vain ajaa
# mitä vain linux-binääriä (kuten godot-pelin julkaisupakettia). Ajamalla tämän
# tiedoston nix-shell - komennolla voi väliaikaisesti asentaa steam-run-työkalun
# jolla näitä binäärejä voi ajaa.

{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

(pkgs.buildFHSEnv {
  name = "simple-x11-env";
  targetPkgs = pkgs: (with pkgs; [
    steam-run
  ]) ++ (with pkgs.xorg; [

  ]);
  multiPkgs = pkgs: (with pkgs; [
  ]);
  runScript = "bash";
}).env
