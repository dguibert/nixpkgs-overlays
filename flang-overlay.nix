self: super:
let

  flangPackages_39 = let
      callPackages = super.newScope (self // flangPackages_39);
  in (super.llvmPackages_39 // {
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

  flangPackages_4 = let
      callPackages = super.newScope (self // flangPackages_4);
  in (super.llvmPackages_4 // {
    version = "4.0.1";

    clang-unwrapped = callPackages ./overlay-flang/llvm/4/clang { };

    clang = if super.stdenv.cc.isGNU then flangPackages_4.libstdcxxClang else flangPackages_4.libcxxClang;

    libstdcxxClang = flangPackages_4.ccWrapperFun {
      cc = flangPackages_4.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ super.libstdcxxHook ];
    };

    ccWrapperFun = callPackages ./overlay-flang/build-support/cc-wrapper;

    libcxxClang = flangPackages_4.ccWrapperFun {
      cc = flangPackages_4.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ flangPackages_4.libcxx flangPackages_4.libcxxabi ];
    };

    flang-unwrapped = callPackages ./overlay-flang/llvm/4/flang.nix { };

    flang = flangPackages_4.ccWrapperFun {
      cc = flangPackages_4.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ super.libstdcxxHook flangPackages_4.flang-unwrapped ];
    };

    openmp = callPackages ./overlay-flang/llvm/4/openmp.nix { };
  });

  flangPackages_5 = let
      callPackages = super.newScope (self // flangPackages_5);
  in (super.llvmPackages_5 // {
    release_version = "5.0.0";
    version = flangPackages_5.release_version;

    clang-unwrapped = callPackages ./overlay-flang/llvm/5/clang { };

    clang = if super.stdenv.cc.isGNU then flangPackages_5.libstdcxxClang else flangPackages_5.libcxxClang;

    libstdcxxClang = flangPackages_5.ccWrapperFun {
      cc = flangPackages_5.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ super.libstdcxxHook ];
    };

    ccWrapperFun = callPackages ./overlay-flang/build-support/cc-wrapper;

    libcxxClang = flangPackages_5.ccWrapperFun {
      cc = flangPackages_5.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ flangPackages_5.libcxx flangPackages_5.libcxxabi ];
    };

    flang-unwrapped = callPackages ./overlay-flang/llvm/5/flang.nix { };

    flang = flangPackages_5.ccWrapperFun {
      cc = flangPackages_5.clang-unwrapped;
      /* FIXME is this right? */
      inherit (self.stdenv.cc) libc nativeTools nativeLibc;
      extraPackages = [ super.libstdcxxHook flangPackages_5.flang-unwrapped ];
    };

    openmp = callPackages ./overlay-flang/llvm/5/openmp.nix { };
  });
in
{
  
  flangPackages_39 = flangPackages_39;
  flangPackages_4 = flangPackages_4;
  flangPackages_5 = flangPackages_5;

  flangPackages = flangPackages_4;
}
