{ pkgs }: (import ./browsers.nix { inherit pkgs; }) ++ (import ./basic.nix { inherit pkgs; })
