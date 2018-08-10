self: super:
{
  import ../build-support/package-tests {
    inherit (super) runCommand; inherit lib;
  };
}
