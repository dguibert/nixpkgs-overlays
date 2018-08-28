{ stdenv, version, flang_src, cmake, llvm, python}:
let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
in
stdenv.mkDerivation {
  name = "libpgmath-${version}";
  src = flang_src;

  buildInputs = [ cmake llvm gcc python ];

  preConfigure = ''
    # build libpgmath
    cd runtime/libpgmath
  '';
}

