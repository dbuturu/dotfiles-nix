{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';
    # /home/dbuturu/.config/nixos/modules/packages/default.nix
    webapps = pkgs.writeShellApplication {
      name = "webapps";
      runtimeInputs = with pkgs; [ wofi chromium ];
      text = builtins.readFile ./webapps;
    };

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
            abook age ani-cli anki-bin aria2 arandr atool android-tools
            #arkenfox-user.js 
            bat bandw bc bluetui btop
            calcurse chafa corefonts clipboard-jh cups
            dosfstools dunst
            eza
            #exfat-utils
            ffmpeg ffmpegthumbnailer firefox fzf 
            git git-lfs gitAndTools.delta gitAndTools.gh gitAndTools.git-fame gnome-keyring gnupg regreet grim 
            hyprland
            #hyprpaper
            imagemagick
            lf libnotify libreoffice logisim lowdown lua lynx
            #libertinus-font 
            maintenance mediainfo mindustry moreutils mutt-wizard mpc mpd mpv 
            #maim #"can take quick screenshots at your request."
            ncmpcpp nerd-fonts.fira-code neomutt networkmanagerapplet noto-fonts noto-fonts-emoji
            #nsixv #ntfs-3g
            pass poppler pqiv python3 pulsemixer
            qpwgraph
            ripgrep
            screen sc-im simple-mtpfs slock slop socat slurp swww
            tealdeer tesseract
            #task-spooler #tesseract-data-eng #ttf-dejavu #ttf-font-awesome
            unzip
            vscode
            webapps wf-recorder winbox4 wireplumber wofi
            yt-dlp
            zathura zig zip zk
            #zathura-pdf-mupdf #zsh-fast-syntax-highlighting-git 
        ];
    };
}
