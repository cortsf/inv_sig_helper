{
  description = "Rust service that decrypts YouTube signatures and manages player information.";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.11;
    import-cargo.url = github:edolstra/import-cargo;
  };

  outputs = { self, nixpkgs, import-cargo }: let

    inherit (import-cargo.builders) importCargo;

  in {

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "inv_sig_helper";
        src = self;

        nativeBuildInputs = [
          (importCargo { lockFile = ./Cargo.lock; inherit pkgs; }).cargoHome
          rustc cargo openssl pkg-config
        ];

        buildPhase = ''
          cargo build --release --offline
        '';

        installPhase = ''
          install -Dm775 ./target/release/inv_sig_helper_rust $out/bin/inv_sig_helper
        '';

      };

  };
}
