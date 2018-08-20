self: super:
{
  lib = (super.lib or {}) // rec {
    package-tests = import ./build-support/package-tests {
      inherit (super) runCommand lib;
    };
    inherit (package-tests) withTests;
  };
}
