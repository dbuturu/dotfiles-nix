{ lib, fetchFromGitHub, cmake, hyprland, hyprlandPlugins }:

hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprriver";
  version = "master";
  src = fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprRiver";
    rev = "master";
    hash = "sha256-0000000000000000000000000000000000000000000000000000"; # <-- Replace after first build
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [];
  meta = {
    homepage = "https://github.com/zakk4223/hyprRiver";
    description = "Hyprland river-like tiling plugin";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}