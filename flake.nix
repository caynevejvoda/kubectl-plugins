{
  description = "Interactive kubectl plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    scram-sha-256 = {
      url = "github:supercaracal/scram-sha-256/v1.1.1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, scram-sha-256 }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          scram = pkgs.buildGoModule {
            pname = "scram-sha-256";
            version = "1.1.1";
            src = scram-sha-256;
            vendorHash = "sha256-GlwDnvLCTNLID0SW1wHh4f5O1t0sz+NX/k4RdC1jKk0=";
            subPackages = [ "cmd/term" ];
            postInstall = ''
              mv "$out/bin/term" "$out/bin/scram-sha-256"
            '';
          };

          commonRuntimeInputs = with pkgs; [ bash kubectl gum ];

          mkPlugin = name: extraRuntimeInputs:
            pkgs.stdenvNoCC.mkDerivation {
              pname = name;
              version = "0-unstable";
              src = self;
              nativeBuildInputs = [ pkgs.makeWrapper ];
              dontBuild = true;
              installPhase = ''
                runHook preInstall
                install -Dm755 ${name} "$out/bin/${name}"
                wrapProgram "$out/bin/${name}" \
                  --prefix PATH : ${pkgs.lib.makeBinPath (commonRuntimeInputs ++ extraRuntimeInputs)}
                runHook postInstall
              '';
              meta = {
                description = "Interactive kubectl plugin ${nixpkgs.lib.removePrefix "kubectl-" name}";
                license = pkgs.lib.licenses.mit;
                platforms = pkgs.lib.platforms.unix;
              };
            };

          plugins = {
            kubectl-ctx = mkPlugin "kubectl-ctx" [ ];
            kubectl-ns = mkPlugin "kubectl-ns" [ ];
            kubectl-use = mkPlugin "kubectl-use" [ ];
            kubectl-createsecret = mkPlugin "kubectl-createsecret" [ ];
            kubectl-create_sealed_secret = mkPlugin "kubectl-create_sealed_secret" [ pkgs.coreutils pkgs.kubeseal pkgs.yq ];
            kubectl-create_cnpg_role_secret = mkPlugin "kubectl-create_cnpg_role_secret" [ pkgs.coreutils scram ];
            kubectl-cilium_health_status = mkPlugin "kubectl-cilium_health_status" [ ];
            kubectl-debug_pod = mkPlugin "kubectl-debug_pod" [ ];
          };
        in
          plugins // {
            default = pkgs.symlinkJoin {
              name = "kubectl-plugins";
              paths = builtins.attrValues plugins;
            };
          });
    };
}
