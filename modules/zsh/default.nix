{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };

    config = mkIf cfg.enable {
    	home.packages = [
	        pkgs.zsh
	    ];

        programs.zsh = {
            enable = true;

            # directory to put config files in
            dotDir = ".config/zsh";

            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            # .zshrc
            initContent = ''
                PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b |.%F{red}?) %f"

                export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
                export ZK_NOTEBOOK_DIR="~/notes";
                export DIRENV_LOG_FORMAT="";
                bindkey '^ ' autosuggest-accept

                edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
                ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
            '';

            # basically aliases for directories: 
            # `cd ~dots` will cd into ~/.config/nixos
            dirHashes = {
                dots = "$HOME/.config/nixos";
                stuff = "$HOME/stuff";
                media = "/run/media/$USER";
                junk = "$HOME/other";
            };

            # Tweak settings for history
            history = {
                save = 1000;
                size = 1000;
                path = "$HOME/.cache/zsh_history";
            };

            # Set some aliases
            shellAliases = {
                mkdir = "mkdir -vp";
                rm = "rm -rifv";
                mv = "mv -iv";
                cp = "cp -riv";
                cat = "bat --paging=never --style=plain";
                ls = "exa -a --icons";
                tree = "exa --tree --icons";
                nd = "nix develop -c $SHELL";
                rebuild = "doas nixos-rebuild switch --flake $NIXOS_CONFIG_DIR --fast; notify-send 'Rebuild complete\!'";

                # Chromium web app aliases
                notesnook = "${pkgs.chromium}/bin/chromium --app=https://app.notesnook.com";
                keep = "${pkgs.chromium}/bin/chromium --app=https://keep.google.com";
                gmail = "${pkgs.chromium}/bin/chromium --app=https://gmail.google.com";
                uopeople = "${pkgs.chromium}/bin/chromium --app=https://my.uopeople.edu";
                messeseges = "${pkgs.chromium}/bin/chromium --app=https://messages.google.com";
                whatsapp = "${pkgs.chromium}/bin/chromium --app=https://web.whatsapp.com";
                youtube = "${pkgs.chromium}/bin/chromium --app=https://youtube.com";
                netflix = "${pkgs.chromium}/bin/chromium --app=https://netflix.com";
            };

            # Source all plugins, nix-style
            plugins = [
                {
                    name = "auto-ls";
                    src = pkgs.fetchFromGitHub {
                        owner = "notusknot";
                        repo = "auto-ls";
                        rev = "62a176120b9deb81a8efec992d8d6ed99c2bd1a1";
                        sha256 = "08wgs3sj7hy30x03m8j6lxns8r2kpjahb9wr0s0zyzrmr4xwccj0";
                    };
                }
            ];
        };
    };
}
