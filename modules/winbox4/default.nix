{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.winbox4;
  winboxUrl = "https://download.mikrotik.com/winbox/4.0beta11/winbox64.exe"; # Update if necessary
  winboxPath = "${config.xdg.dataHome}/winbox4";
in {
  options.modules.winbox4.enable = mkEnableOption "Winbox 4";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wine64 ];

    home.file."${winboxPath}/winbox64.exe" = {
      source = builtins.fetchurl {
        url = winboxUrl;
        sha256 = "<replace-with-correct-hash>"; # Use `nix-prefetch-url` to get the hash
      };
    };

    home.file."${config.xdg.desktopEntries}/winbox4.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Winbox 4
        Exec=wine64 ${winboxPath}/winbox64.exe
        Type=Application
        Categories=Network;
      '';
    };
  };
}
