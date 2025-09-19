{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.lf;

in {
    options.modules.lf = { enable = mkEnableOption "lf"; };
    config = mkIf cfg.enable {
        programs.lf = {
          enable = true;
          # This script tells lf how to generate previews for different file types.
          previewer.source = pkgs.writeShellScript "lf-preview" ''
            #!/bin/sh
            set -eu

            # Get file metadata
            filepath="$1"
            width="$2"
            height="$3"
            mimetype=$(file --dereference --brief --mime-type -- "$filepath")

            case "$mimetype" in
                image/*)
                    # Display image previews using chafa
                    ${pkgs.chafa}/bin/chafa -s "''${width}x''${height}" --animate off "$filepath"
                    ;;
                *)
                    # Fallback to syntax-highlighted text preview using bat
                    ${pkgs.bat}/bin/bat --color=always --style=plain --paging=never --terminal-width="$width" "$filepath" || cat "$filepath"
                    ;;
            esac
          '';
        };
    };
}
