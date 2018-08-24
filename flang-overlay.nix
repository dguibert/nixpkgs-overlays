self: super:
with super.lib;
let

  flangPackages = llvmPackages: ver: release_version: let
      #callPackages = super.newScope (self // flangPackages_);
      flangPackages_ = (llvmPackages // {
        inherit release_version;
        version = release_version;

        clang-unwrapped = super.callPackage (./. + builtins.toPath "/flang-overlay/llvm/${ver}/clang") {
          inherit (flangPackages_) version release_version llvm;
        };

        clang = if super.stdenv.cc.isGNU then flangPackages_.libstdcxxClang else flangPackages_.libcxxClang;

        libstdcxxClang = flangPackages_.ccWrapperFun {
          cc = flangPackages_.clang-unwrapped;
          /* FIXME is this right? */
          inherit (super.stdenv.cc) libc nativeTools nativeLibc;
	        bintools = super.binutils;
          extraPackages = [ super.libstdcxxHook ];
        };

        ccWrapperFun = super.callPackage ./flang-overlay/build-support/cc-wrapper;

        libcxxClang = flangPackages_.ccWrapperFun {
          cc = flangPackages_.clang-unwrapped;
          /* FIXME is this right? */
          inherit (super.stdenv.cc) libc nativeTools nativeLibc;
      	  bintools = super.binutils;
          extraPackages = [ flangPackages_.libcxx flangPackages_.libcxxabi ];
        };

        flang-unwrapped = super.callPackage (./. + builtins.toPath "/flang-overlay/llvm/${ver}/flang.nix") {
          inherit (flangPackages_) version openmp llvm clang;
        };

        flang = flangPackages_.ccWrapperFun {
          cc = flangPackages_.clang-unwrapped;
          /* FIXME is this right? */
          inherit (super.stdenv.cc) libc nativeTools nativeLibc;
	        bintools = super.binutils;
          extraPackages = [ super.libstdcxxHook flangPackages_.flang-unwrapped ];
        };

        openmp = super.callPackage (./. + builtins.toPath "/flang-overlay/llvm/${ver}/openmp.nix") {
          inherit (flangPackages_) version llvm;
        };

        llvm = super.callPackage (./. + builtins.toPath "/flang-overlay/llvm/${ver}/llvm.nix") {
          inherit (flangPackages_) version release_version;
        };
      });
    in flangPackages_;

in
{
  
  flangPackages_39 = flangPackages super.llvmPackages_39 "39" "3.9.1";
  flangPackages_4  = flangPackages super.llvmPackages_4  "4" "4.0.1";
  flangPackages_5  = flangPackages super.llvmPackages_5  "5" "5.0.2";
  flangPackages_6  = flangPackages super.llvmPackages_6  "6" "6.0.1";

}
