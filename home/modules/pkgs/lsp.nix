{pkgs, inputs, ...}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
  {
  home.packages = with pkgs; [
    tree-sitter

    # C/C++
    clang-tools

    # Rust
    rustfmt
    rust-analyzer

    # Nix
    nixd

    # Lua
    lua-language-server
    stylua

    # Web
    nodePackages.typescript-language-server
    prettierd # Formatter
    tailwindcss-language-server

    # Python
    pyright

    # Java
    jdt-language-server

    # YAML
    yaml-language-server

    # Bash
    bash-language-server
  ];
}
