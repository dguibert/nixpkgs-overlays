self: super:
{
  flangPackages_5 = super.callPackage ./flang-overlay/llvm/5 { };
  flangPackages_6 = super.callPackage ./flang-overlay/llvm/6 { };
}
