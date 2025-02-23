{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.chromiumWebApps;
  apps = [
    { name = "WhatsApp"; url = "https://web.whatsapp.com"; }
    { name = "Gmail"; url = "https://mail.google.com"; }
    { name = "GoogleKeep"; url = "https://keep.google.com"; }
		{ name = "notesnook"; url = "https://app.notesnook.com";}
  ];
in {
  options.modules.chromiumWebApps = {
    enable = mkEnableOption "Enable Chromium-based web apps";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ chromium wofi jq ];

    home.activation.chromiumWebApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.local/share/applications"
      mkdir -p "$HOME/.local/bin/chromium-web-apps"

      APPS_JSON='${builtins.toJSON apps}'
      echo "$APPS_JSON" | jq -c '.[]' | while read -r app; do
        name=$(echo "$app" | jq -r '.name')
        url=$(echo "$app" | jq -r '.url')
        EXEC="$HOME/.local/bin/chromium-web-apps/$name"
        echo "#!/bin/sh" > "$EXEC"
        echo "exec ${pkgs.chromium}/bin/chromium --app=$url --new-window" >> "$EXEC"
        chmod +x "$EXEC"
        echo "[Desktop Entry]
Name=$name
Exec=$EXEC
Terminal=false
Type=Application
Categories=Network;" > "$HOME/.local/share/applications/$name.desktop"
      done
    '';

    home.file.".local/bin/wofi-chromium-apps.sh".text = ''
      #!/bin/sh
      APP_PATH="$HOME/.local/bin/chromium-web-apps"
      choice=$(ls "$APP_PATH" | wofi --dmenu -p "Launch Web App")
      [ -n "$choice" ] && "$APP_PATH/$choice"
    '';

    home.file.".local/share/applications/wofi-chromium-apps.desktop".text = ''
      [Desktop Entry]
      Name=Chromium Web Apps
      Comment=Launch Chromium Web Apps via Wofi
      Exec=$HOME/.local/bin/wofi-chromium-apps.sh
      Terminal=false
      Type=Application
      Categories=Network;
    '';
  };
}
