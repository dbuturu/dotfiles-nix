{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.st; # Renamed PROGRAM to st

in {
  options.modules.st = { # Renamed PROGRAM to st
    enable = mkEnableOption "Luke Smith's st terminal";
  };

  config = mkIf cfg.enable {
    # Install st for the user via home.packages
    home.packages = with pkgs; [
      (stdenv.mkDerivation {
        pname = "st-lukesmithxyz";
        version = "2025-06-28"; # You can update this based on the commit date or a specific release

        # Fetch the source code from GitHub
        src = fetchFromGitHub {
          owner = "lukesmithxyz";
          repo = "st";
          rev = "62ebf672322307137f225ec0d3d3a1fb4d2572b9"; # Using a specific commit hash for stability
          # IMPORTANT: Replace this with the actual SHA256 hash after the first build.
          # You can get the correct hash by setting it to "lib.fakeSha256" and running nix-build.
          # The error message will provide the correct hash.
          sha256 = lib.fakeSha256;
        };

        # Build inputs required for st (X11 libraries, font rendering)
        buildInputs = with xorg; [
          libX11
          libXft
          libXrandr
          fontconfig # For font configuration
          harfbuzz # For text shaping
        ];

        # Standard build phases for a C program using make
        buildPhase = ''
          # You might want to edit config.h before building if you need custom patches or settings.
          # For example, to set default font or colors:
          # cp config.def.h config.h
          # sed -i 's/"monospace:pixelsize=14:antialias=true:autohint=true"/"Fira Mono:pixelsize=12:antialias=true:autohint=true"/' config.h
          make
        '';

        installPhase = ''
          mkdir -p $out/bin
          make install PREFIX=$out
        '';

        # Add any other required dependencies if 'make' fails due to missing headers/libraries.
        meta = with lib; {
          description = "Luke Smith's fork of the suckless simple terminal (st)";
          homepage = "https://github.com/lukesmithxyz/st";
          license = licenses.mit; # st is MIT licensed
          platforms = platforms.linux; # Primarily for Linux
        };
      })
    ];
  };
}