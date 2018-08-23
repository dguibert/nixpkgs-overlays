let
  # https://vaibhavsagar.com/blog/2018/05/27/quick-easy-nixpkgs-pinning/
  fetcher = { owner, repo, rev, sha256 }: builtins.fetchTarball {
      inherit sha256;
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      };
  # ./updater versions.json nixpkgs pu
  #inherit (import <nixpkgs> {}) lib;
  #versions = lib.mapAttrs
  #   (_: fetcher)
  #     (builtins.fromJSON (builtins.readFile ./versions.json));
  versions_nixpkgs = fetcher (builtins.fromJSON (builtins.readFile ./versions.json)).nixpkgs;
in
{ nixpkgsSrc ? versions_nixpkgs
, overlays_ ? []
}:
import nixpkgsSrc {
 # Makes the config pure as well.
 # See <nixpkgs>/top-level/impure.nix:
 config = { };
 overlays = [
   (import ./all-packages.nix)
   (import ./flang-overlay.nix)
   (import ./slurm-jobs-overlay.nix)
   (import ./intel-compilers-overlay.nix)
 ] ++ overlays_;
}
