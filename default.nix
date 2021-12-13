{ pkgs ? import (import ./nix/sources.nix {}).nixpkgs {} }: 
{
    tools = {
        sqlite3 = pkgs.sqlite;
        node = pkgs.nodejs;
        yarn = pkgs.yarn;
        colmena = pkgs.colmena;
        niv = pkgs.niv;
    };
}