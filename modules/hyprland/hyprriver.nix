 { lib, pkgs, fetchFromGitHub, hyprland, hyprlandPlugins }:

hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprriver";
  version = "main"; # Using 'main' branch is not reproducible. Consider pinning to a commit.
  src = fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprRiver";
    rev = "main"; # e.g. "9b2423a2134a6211603598b9eda93f4153093952"
    hash = "sha256-o5t48zkNeuxUmI2RW13PUFqbx70hG5i7l8vmfuZ76zY=";
  };

  # This project uses a Makefile which has dependencies.
  nativeBuildInputs = [ pkgs.make pkgs.pkg-config pkgs.wayland-protocols ];
  buildInputs = [ pkgs.pixman pkgs.libdrm ];

  # The Makefile produces 'riverLayoutPlugin.so'. We need to install it as 'hyprriver.so'.
  # We override the installPhase to copy the built plugin to the correct location.
  # The default buildPhase will run 'make' for us.
  installPhase = ''
    runHook preInstall
    install -D riverLayoutPlugin.so $out/lib/${pluginName}.so
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/zakk4223/hyprRiver";
    description = "Hyprland river-like tiling plugin";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}