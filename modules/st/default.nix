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
        version = "2024-03-12"; # Updated to match the new commit date

        # Fetch the source code from GitHub
        src = fetchFromGitHub {
          owner = "lukesmithxyz";
          repo = "st";
          rev = "62ebf677d3ad79e0596ff610127df5db034cd234"; # Updated to a valid, recent commit
          # IMPORTANT: Replace this with the actual SHA256 hash after the first build.
          # You can get the correct hash by setting it to "lib.fakeSha256" and running nix-build.
          # The error message will provide the correct hash.
          sha256 = "sha256-L4FKnK4k2oImuRxlapQckydpAAyivwASeJixTj+iFrM=";
        };

        # Tools required to build the package.
        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.ncurses # for the 'tic' command
        ];

        # Build inputs required for st (X11 libraries, font rendering)
        buildInputs = with xorg; [
          libX11
          libXft
          libXrandr
          fontconfig # For font configuration
          freetype   # For font rendering
          harfbuzz # For text shaping
        ];

        # The `tic` command tries to write to the user's home directory by default.
        # In the sandboxed build environment, this fails due to permissions.
        # We patch the Makefile to tell `tic` to install the terminfo files
        # into the correct location within the package's output directory.
        postPatch = ''
          substituteInPlace Makefile --replace "tic -sx st.info" "tic -sx -o \${PREFIX}/share/terminfo st.info"
        '';

        # The standard build process for `st` uses `make` and `make install`.
        # We can rely on the default build- and install-phases from stdenv,
        # but we must tell `make` where to install the files by setting the PREFIX variable.
        makeFlags = [ "PREFIX=${placeholder "out"}" ];

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