{
  description = "Tasks.org Desktop App Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pname = "tasks-desktop";
        version = "15.12";

        src = pkgs.fetchurl {
          url = "https://github.com/tasks/tasks/releases/download/${version}/tasks-org-linux-x86_64.AppImage";
          sha256 = "sha256-W8DEvrXo/kIEjvPJTGnCHHcJLt3o4rNEuPWYSv2oPDg=";
        };

        appimageContents = pkgs.appimageTools.extract {
          inherit pname version src;
        };

        tasks-app = pkgs.appimageTools.wrapType2 {
          inherit pname version src;

          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/*.desktop -t $out/share/applications

            substituteInPlace $out/share/applications/*.desktop \
              --replace-warn 'Exec=tasks-org' 'Exec=${pname}'

            if [ -d "${appimageContents}/usr/share/icons" ]; then
              install -d $out/share/icons
              cp -r ${appimageContents}/usr/share/icons/* $out/share/icons/
            fi
          '';
        };
      in
      {
        packages.default = tasks-app;
        apps.default = {
          type = "app";
          program = "${tasks-app}/bin/${pname}";
        };
      }
    );
}
