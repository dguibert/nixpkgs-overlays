self: super:
let

  flangPackages = llvmPackages: ver: release_version: let
      callPackages = super.newScope (self // flangPackages_);
      flangPackages_ = (llvmPackages // {
        inherit release_version;
        version = release_version;

        clang-unwrapped = callPackages (./. + builtins.toPath "/flang-overlay/llvm/${ver}/clang") { };

        clang = if super.stdenv.cc.isGNU then flangPackages_.libstdcxxClang else flangPackages_.libcxxClang;

        libstdcxxClang = flangPackages_.ccWrapperFun {
          cc = flangPackages_.clang-unwrapped;
          /* FIXME is this right? */
          inherit (self.stdenv.cc) libc nativeTools nativeLibc;
	  bintools = super.binutils;
          extraPackages = [ super.libstdcxxHook ];
        };

        ccWrapperFun = callPackages ./flang-overlay/build-support/cc-wrapper;

        libcxxClang = flangPackages_.ccWrapperFun {
          cc = flangPackages_.clang-unwrapped;
          /* FIXME is this right? */
          inherit (self.stdenv.cc) libc nativeTools nativeLibc;
          extraPackages = [ flangPackages_.libcxx flangPackages_.libcxxabi ];
        };

        flang-unwrapped = callPackages (./. + builtins.toPath "/flang-overlay/llvm/${ver}/flang.nix") { };

        flang = flangPackages_.ccWrapperFun {
          cc = flangPackages_.clang-unwrapped;
          /* FIXME is this right? */
          inherit (self.stdenv.cc) libc nativeTools nativeLibc;
	  bintools = super.binutils;
          extraPackages = [ super.libstdcxxHook flangPackages_.flang-unwrapped ];
        };

        openmp = callPackages (./. + builtins.toPath "/flang-overlay/llvm/${ver}/openmp.nix") { };
      });
    in flangPackages_;

in
{
  
  flangPackages_39 = flangPackages super.llvmPackages_39 "39" "3.9.0";
  flangPackages_4  = flangPackages super.llvmPackages_4  "4" "4.0.1";
  flangPackages_5  = flangPackages super.llvmPackages_5  "5" "5.0.1";

}
