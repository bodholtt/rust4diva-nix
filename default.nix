# default.nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  libarchive,
  openssl,
  fontconfig,
  libxkbcommon,
  wayland,
  libGL,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  libxcb,
  xdg-utils,
}:

let
  runtimeLibs = [
    libxkbcommon
    wayland
    libGL
    libx11
    libxcursor
    libxrandr
    libxi
    libxcb
    fontconfig
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "rust4diva";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "R3alCl0ud";
    repo = "Rust4Diva";
    tag = "v${version}";
    hash = "sha256-yBe6AIq/wGo2ASIhZRQ5BaY+bo1tIx9jbFgXoyuq/xI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-yfl4ZHocny6vjsopnJERChF6FLSm6/faUSH3YlxTk1s=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Linked at build time
  buildInputs = [
    libarchive
    openssl
    fontconfig
  ] ++ runtimeLibs;

  postFixup = ''
    wrapProgram $out/bin/rust4diva \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  doCheck = false;

  meta = {
    description = "A Fast cross-platform mod manager written in rust for the steam version of Hatsune Miku Project Diva Mega Mix +";
    homepage = "https://github.com/R3alCl0ud/Rust4Diva";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rust4diva";
    platforms = lib.platforms.linux;
  };
}
