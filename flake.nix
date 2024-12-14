{
  description = "K8s Learning Course";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      bootdev-cli = pkgs.buildGoModule rec {
        pname = "bootdev";
        version = "1.11.1";

        src = pkgs.fetchFromGitHub {
          owner = "bootdotdev";
          repo = "bootdev";
          rev = "v${version}";
          hash = "sha256-4XOXYcC+ghvyZ9oFg/kXn/1MdseMPIWzR4CFMVWrukw=";
        };

        vendorHash = "sha256-jhRoPXgfntDauInD+F7koCaJlX4XDj+jQSe/uEEYIMM=";

        meta = {
          description = "The official CLI for boot.dev";
          homepage = "https://github.com/bootdotdev/bootdev";
        };
      };
    in
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-added-large-files.enable = true;
            deadnix.enable = true;
            end-of-file-fixer.enable = true;
            nixfmt-rfc-style.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      };

      devShell."${system}" = pkgs.mkShell {
        inherit (self.checks.pre-commit-check) shellHook;
        buildInputs = self.checks.pre-commit-check.enabledPackages;

        packages = with pkgs; [
          bootdev-cli
          just
          k9s
          kubectl
          minikube
          nil
          nixpkgs-fmt
          pre-commit
        ];
      };
    };
}
