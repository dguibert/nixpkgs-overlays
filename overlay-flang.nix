self: super:
let
  callPackages = super.newScope (self // flangPackages_39);

  flangPackages_39 = (super.llvmPackages_39 // {
    version = "3.9.1";

    clang-unwrapped = callPackages ./overlay-flang/llvm/3.9/clang { };

    clang = if super.stdenv.cc.isGNU then flangPackages_39.libstdcxxClang else flangPackages_39.libcxxClang;

    libstdcxxClang = flangPackages_39.ccWrapperFun {
      cc = flangPackages_39.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ super.libstdcxxHook ];
    };

    ccWrapperFun = callPackages ./overlay-flang/build-support/cc-wrapper;

    libcxxClang = flangPackages_39.ccWrapperFun {
      cc = flangPackages_39.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ flangPackages_39.libcxx flangPackages_39.libcxxabi ];
    };

    flang-unwrapped = callPackages ./overlay-flang/llvm/3.9/flang.nix { };

    flang = flangPackages_39.ccWrapperFun {
      cc = flangPackages_39.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ super.libstdcxxHook flangPackages_39.flang-unwrapped ];
    };

    openmp = callPackages ./overlay-flang/llvm/3.9/openmp.nix { };
  });
in
{
  
  flangPackages_39 = flangPackages_39;
  flangPackages = flangPackages_39;
}
