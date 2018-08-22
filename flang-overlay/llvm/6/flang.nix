{ stdenv, fetchFromGitHub, cmake, clang, openmp, llvm, version, python }:

let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  self = stdenv.mkDerivation {
    name = "flang-${version}";

    buildInputs = [ cmake llvm clang python ];
    propagatedBuildInputs = [ openmp ];

    NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-builtin-memcpy-chk-size";

    src = fetchFromGitHub {
      owner = "flang-compiler";
      repo = "flang";
      rev = "master";
      sha256 = "0rry61hqr6xig7957smdsav375glas2wsg9akyxpxj27rrnax8w5";
    };

    cmakeFlags = [
      "-DTARGET_ARCHITECTURE=x86_64" # uname -i
      "-DTARGET_OS=Linux"            # uname -s
      "-DCMAKE_CXX_FLAGS=-std=c++11"
      "-DCMAKE_CXX_COMPILER=clang++"
      "-DCMAKE_C_COMPILER=clang"
      "-DCMAKE_Fortran_COMPILER=flang"
      "-DLLVM_CONFIG=${llvm}/bin/llvm-config"
    ];

    postFixup = ''
      rpath=$(patchelf --print-rpath $out/lib/libflang.so)
      patchelf --set-rpath ${openmp}/lib:$out/lib/libflang.so:$rpath $out/lib/libflang.so
    '';

    preConfigure = ''
      # build libpgmath
      cd runtime/libpgmath
      mkdir build
      cd build
      cmake $cmakeFlags -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ..
      make
      make install
      cd -
    '';

    enableParallelBuilding = true;

    passthru = {
      isClang = true;
      langFortran = true;
      # https://bugs.llvm.org/show_bug.cgi?id=23277#c2
      hardeningUnsupportedFlags = [ "fortify" ];
      inherit llvm;
    } // stdenv.lib.optionalAttrs stdenv.isLinux {
      inherit gcc;
    };

    meta = {
      description = "A fortran frontend for the llvm compiler";
      homepage    = http://llvm.org/;
      license     = stdenv.lib.licenses.ncsa;
      platforms   = stdenv.lib.platforms.all;
    };
  };
in self
