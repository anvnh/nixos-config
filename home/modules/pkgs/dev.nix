{pkgs, inputs, ...}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
  {
  home.packages = with pkgs; [
    # Compilers, Runtimes & SDKs
    gcc                                 # C/C++
    python310                           # Python
    nodejs                              # Node.js
    jdk17                               # Java
    rustc                               # Rust Core
    flutter                             # Flutter SDK

    # Build Tools & Package Managers
    cmake
    gnumake
    cargo                               # Rust package manager
    pnpm                                # JS package manager
    yarn                                # JS package manager
    android-tools                       # ADB, fastboot
  ];
}
