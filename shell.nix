{ pkgs ? import <nixos> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
in

mkShell {
  buildInputs = [
    elixir_1_15
    elixir-ls
  ]
  ++ optional stdenv.isLinux glibc
  ++ optional stdenv.isLinux glibcLocales
  ;

  # Fix GLIBC Locale
  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE = lib.optionalString stdenv.isLinux
    "${pkgs.glibcLocales}/lib/locale/locale-archive";
  ERL_INCLUDE_PATH="${pkgs.erlang}/lib/erlang/usr/include";

  shellHook = ''
  '';

}
