{ stdenv, fetchFromGitHub, cmake, llvm, version, perl, python, gfortran, hwloc }:

stdenv.mkDerivation {
  name = "openmp-${version}";

  src = fetchFromGitHub {
    owner = "llvm-mirror";
    repo = "openmp";
    rev = "release_40";
    sha256 = "05nbi7x21w84hh0q3ylkw5n6j9xxa9hqs6hkyg9yxf28kp00jmaf";
  };

  buildInputs = [ cmake llvm perl python gfortran hwloc ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLIBOMP_FORTRAN_MODULES=on"
    "-DLIBOMP_USE_HWLOC=on"
  ];

  preConfigure = "sourceRoot=$PWD/openmp-*/runtime";

  enableParallelBuilding = true;

  meta = {
    description = "An OpenMP runtime for the llvm compiler";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };

}
