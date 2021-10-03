{ pkgs }: 
{
    friend = pkgs.writeScriptBin "friend" ''
        echo "friend";
    '';
}