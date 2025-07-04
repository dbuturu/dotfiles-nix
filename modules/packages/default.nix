{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
            ripgrep tealdeer
            gnupg
            grim slurp slop
            imagemagick age
            python3 lua  pqiv
            screen bandw maintenance
            wf-recorder anki-bin #arkenfox-user.js #exfat-utils
            eww #gtk-theme-arc-gruvbox-git
            #hyprpaper #libertinus-font 
            #maim #"can take quick screenshots at your request."
            #nsixv #ntfs-3g #task-spooler
            #tesseract-data-eng #ttf-dejavu #ttf-font-awesome
            #zathura-pdf-mupdf #zsh-fast-syntax-highlighting-git abook
            ani-cli arandr atool android-tools
            bat bc bluetui btop
            calcurse corefonts clipboard-jh cups
            dosfstools dunst eza ffmpeg
            ffmpegthumbnailer firefox fzf 
            git git-lfs gitAndTools.delta gitAndTools.gh gitAndTools.git-fame
            gnome-keyring greetd.regreet hyprland kitty
            lf libnotify libreoffice lowdown
            lynx mediainfo mindustry moreutils mutt-wizard
            mpc mpd mpv
            ncmpcpp neomutt
            networkmanagerapplet noto-fonts noto-fonts-emoji
            onlyoffice-desktopeditors pass poppler pulsemixer qpwgraph sc-im
            simple-mtpfs slock socat
            swww tesseract unzip
            vscode winbox4 wireplumber wofi
            yt-dlp zathura zig zk
        ];
    };
}
