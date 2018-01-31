{ stdenv, fetchurl, glibc, gcc, gnumake, which
, preinstDir ? "/scratch/intel"
, version ? "2017"
}:

let
self = stdenv.mkDerivation rec {
  inherit version;
  name = "intel-compilers-${version}";
  sourceRoot = 
    if builtins.pathExists preinstDir then
      preinstDir
    else
      abort ''

        ******************************************************************************************
        Specified preinstDir (${preinstDir}) directory not found.
        To build this package, you have to first get and install locally the Intel Parallel Studio
        distribution with the official installation script provided by Intel.
        Then, set-up preinstDir to point to the directory of the local installation.
        ******************************************************************************************
      '';

  buildInputs = [ glibc gcc gnumake which ];

  phases = [ "installPhase" "fixupPhase" "installCheckPhase" "distPhase" ];

  dontPatchELF = true;
  dontStrip = true;
  # /nix/store/1manigbaw9s3891iwdmc52vq1r25809y-stdenv/setup: xmalloc: subst.c:5586: cannot allocate 256 bytes (16777216 bytes allocated)
  noAuditTmpdir = true;

  installPhase = ''
     cp -a $sourceRoot $out
     # Fixing man path
     rm -f $out/documentation
     rm -f $out/man
     #mkdir -p $out/share
     #ln -s ../compilers_and_libraries/linux/man/common $out/share/man
     export PATH=$out/bin:$PATH

     echo "Fixing path into scripts..."
     for file in `grep -l -r "$sourceRoot" $out`
     do
       sed -e "s,$sourceRoot,$out,g" -i $file
     done

     source $out/bin/compilervars.sh intel64 || true
     export FC=ifort
     echo "Building MKL interfaces..."
     cd $out/mkl/interfaces
     for i in *
     do
       echo "Building $i..."
       cd $i
       make libintel64 INSTALL_DIR=.
       rm -rf obj_*
       cd ..
     done
  '';

  postFixup = ''
    echo "Fixing rights..."
    chmod u+w -R $out
    echo "Patching rpath and interpreter..."
    find $out -type f -executable -exec $SHELL -c 'patchelf --set-interpreter $(echo ${glibc}/lib/ld-linux*.so.2) --set-rpath ${glibc}/lib:${gcc.cc}/lib:${gcc.cc.lib}/lib:\$ORIGIN:\$ORIGIN/../lib 2>/dev/null {}' \;
    echo "Fixing path into scripts..."
    for file in `grep -l -r "$sourceRoot" $out`
    do
      sed -e "s,$sourceRoot,$out,g" -i $file
    done

    libc=$(dirname $(dirname $(echo ${glibc}/lib/ld-linux*.so.2)))
    for comp in icc icpc ifort ; do
      echo "-idirafter $libc/include -dynamic-linker $(echo ${glibc}/lib/ld-linux*.so.2)" >> $out/bin/intel64/$comp.cfg
    done
 
    for comp in icc icpc ifort xild xiar; do
      echo "#!/bin/sh" > $out/bin/$comp
      echo "export PATH=${gcc}/bin:${gcc.cc}/bin:\$PATH" >> $out/bin/$comp
      echo "source $out/bin/compilervars.sh intel64" >> $out/bin/$comp
      echo "$out/bin/intel64/$comp \"\$@\"" >> $out/bin/$comp
      chmod +x $out/bin/$comp
    done

    ln -s $out/compiler/lib/intel64_lin $out/lib
  '';

  enableParallelBuilding = true;

  passthru = {
    lib = self; # compatibility with gcc, so that `stdenv.cc.cc.lib` works on both                                   
    isIntelCompilers = true;
    langFortran = true;
  } // stdenv.lib.optionalAttrs stdenv.isLinux {                                                                     
    inherit gcc;
  };

  meta = {
    description = "Intel compilers and libraries 2017";
    maintainers = [ stdenv.lib.maintainers.dguibert ];
    platforms = stdenv.lib.platforms.linux;
  };
};
in self
