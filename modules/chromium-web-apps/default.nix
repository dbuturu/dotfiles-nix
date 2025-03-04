{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.chromiumApp;
in {
  options.modules.chromiumApp = {
    enable = mkEnableOption "Chromium auto-launch and app aliases";
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically launch Chromium at boot.";
    };
  };

  config = mkIf cfg.enable {
    # Auto-start Chromium on user login
    systemd.user.services.chromium = mkIf cfg.autostart {
      Unit = {
        Description = "Start Chromium on boot";
        After = [ "graphical.target" ];
      };
      Service = {
        ExecStart = "${pkgs.chromium}/bin/chromium";
        Restart = "always";
      };
      Install = { WantedBy = [ "default.target" ]; };
    };

  };
}
