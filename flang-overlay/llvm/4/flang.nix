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
      sha256 = "0qayjr5kc04bi8yanj4k1wviby99j11ka2wbbb00xxy9l3qyrkd6";
    };

    cmakeFlags = [
      "-DTARGET_ARCHITECTURE=x86_64" # uname -i
      "-DTARGET_OS=Linux"            # uname -s
      "-DCMAKE_CXX_FLAGS=-std=c++11"
      "-DCMAKE_CXX_COMPILER=clang++"
      "-DCMAKE_C_COMPILER=clang"
      "-DCMAKE_Fortran_COMPILER=flang"
    ];

    postFixup = ''
      rpath=$(patchelf --print-rpath $out/lib/libflang.so)
      patchelf --set-rpath ${openmp}/lib:$out/lib/libflang.so:$rpath $out/lib/libflang.so
    '';

    enableParallelBuilding = true;

    passthru = {
      lib = self; # compatibility with gcc, so that `stdenv.cc.cc.lib` works on both
      isClang = true;
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
