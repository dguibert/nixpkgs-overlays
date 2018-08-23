self: super:
with super.lib;
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
      	  bintools = super.binutils;
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

        llvm = callPackages (./. + builtins.toPath "/flang-overlay/llvm/${ver}/llvm.nix") { };
      });
    in flangPackages_;

in
{
  
  flangPackages_39 = flangPackages super.llvmPackages_39 "39" "3.9.1";
  flangPackages_4  = flangPackages super.llvmPackages_4  "4" "4.0.1";
  flangPackages_5  = flangPackages super.llvmPackages_5  "5" "5.0.2";
  flangPackages_6  = flangPackages super.llvmPackages_6  "6" "6.0.1";

}
