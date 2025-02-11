{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.electronWebApps;
  apps = [
    { name = "WhatsApp"; url = "https://web.whatsapp.com"; }
    { name = "Gmail"; url = "https://mail.google.com"; }
    { name = "GoogleKeep"; url = "https://keep.google.com"; }
  ];
in {
  options.modules.electronWebApps = {
    enable = mkEnableOption "Electron-based web apps";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ electron wofi ];

    home.activation.electronWebApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.local/electron-web-apps"
      for app in ${builtins.toJSON apps}; do
        name=$(echo $app | jq -r '.name')
        url=$(echo $app | jq -r '.url')
        APP_DIR="$HOME/.local/electron-web-apps/$name"
        mkdir -p "$APP_DIR"
        echo "Creating Electron wrapper for $name..."

        cat > "$APP_DIR/main.js" <<EOF
        const { app, BrowserWindow } = require('electron');
        let win;
        app.on('ready', () => {
          win = new BrowserWindow({ width: 1200, height: 800 });
          win.loadURL('${url}');
        });
        EOF

        cat > "$APP_DIR/package.json" <<EOF
        {
          "name": "$name",
          "version": "1.0.0",
          "main": "main.js",
          "dependencies": {}
        }
        EOF

        echo "#!/bin/sh" > "$APP_DIR/$name"
        echo "exec ${pkgs.electron}/bin/electron '$APP_DIR'" >> "$APP_DIR/$name"
        chmod +x "$APP_DIR/$name"
      done
    '';

    home.file.".local/bin/wofi-electron-apps.sh".text = ''
      #!/bin/sh
      APP_PATH="$HOME/.local/electron-web-apps"
      choice=$(ls "$APP_PATH" | wofi --dmenu -p "Launch Web App")
      [ -n "$choice" ] && "$APP_PATH/$choice/$choice"
    '';

    home.file.".local/share/applications/wofi-electron-apps.desktop".text = ''
      [Desktop Entry]
      Name=Electron Web Apps
      Comment=Launch Electron Web Apps via Wofi
      Exec=$HOME/.local/bin/wofi-electron-apps.sh
      Terminal=false
      Type=Application
      Categories=Network;
    '';

    home.file.".local/share/applications".source = pkgs.runCommandLocal "electron-desktop-files" {} ''
      mkdir -p $out
      for app in ${builtins.toJSON apps}; do
        name=$(echo $app | jq -r '.name')
        echo "[Desktop Entry]
        Name=$name
        Exec=$HOME/.local/electron-web-apps/$name/$name
        Terminal=false
        Type=Application
        Categories=Network;" > $out/$name.desktop
      done
    '';
  };
}
