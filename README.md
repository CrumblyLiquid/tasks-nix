# tasks-nix

This flake packages the [Tasks.org](https://tasks.org/) desktop application for NixOS
by simply using the published AppImage artefact
from the [project's GitHub page](https://github.com/tasks/tasks/releases).

## Usage

Add the flake to your inputs:
```nix
tasks-nix = {
  url = "github:CrumblyLiquid/tasks-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then simply add the package:
```nix
environment.systemPackages = [
  inputs.tasks-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

This exposes the app as the `tasks-desktop` binary
but also adds the correct `.desktop` file and icons
to the system environment.
