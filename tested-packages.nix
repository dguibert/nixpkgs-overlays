self: super:
{
  #hello = import ./pkgs/hello { inherit (super) stdenv fetchurl; inherit withTests; };
  hello = super.callPackage ./pkgs/hello { };
}
