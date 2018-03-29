self: super:
{
    # Intel compiler
    intel-compilers = version: preinstDir: rec {
      ccWrapperFun = self.callPackage ./intel-compilers-overlay/cc-wrapper;

      unwrapped = self.callPackages ./intel-compilers-overlay { inherit preinstDir version; };

      wrapped = ccWrapperFun {
        cc = unwrapped;
        /* FIXME is this right? */
	inherit (super.stdenv.cc) libc nativeTools nativeLibc;
	bintools = super.binutils;
        extraPackages = [ super.which super.binutils ];
        isIntelCompilers = true;
      };

      /* Return a modified stdenv that uses Intel compilers */
      stdenv = super.overrideCC super.stdenv wrapped;

      mpi = self.callPackage ./intel-compilers-overlay/mpi.nix { inherit preinstDir version; };
    };

    intel-compilers_2016_0_109 = self.intel-compilers "2016.0.109" "/opt/intel/compilers_and_libraries_2016.0.109/linux";
    intel-compilers_2016_1_150 = self.intel-compilers "2016.1.150" "/opt/intel/compilers_and_libraries_2016.1.150/linux";
    intel-compilers_2016_2_181 = self.intel-compilers "2016.2.181" "/opt/intel/compilers_and_libraries_2016.2.181/linux";
    intel-compilers_2016_3_210 = self.intel-compilers "2016.3.210" "/opt/intel/compilers_and_libraries_2016.3.210/linux";
    intel-compilers_2016_3_223 = self.intel-compilers "2016.3.223" "/opt/intel/compilers_and_libraries_2016.3.223/linux";
    intel-compilers_2016_4_258 = self.intel-compilers "2016.4.258" "/opt/intel/compilers_and_libraries_2016.4.258/linux";
    intel-compilers_2016 = self.intel-compilers_2016_4_258;

    intel-compilers_2017_0_098 = self.intel-compilers "2017.0.098" "/opt/intel/compilers_and_libraries_2017.0.098/linux";
    intel-compilers_2017_1_132 = self.intel-compilers "2017.1.132" "/opt/intel/compilers_and_libraries_2017.1.132/linux";
    intel-compilers_2017_2_174 = self.intel-compilers "2017.2.174" "/opt/intel/compilers_and_libraries_2017.2.174/linux";
    intel-compilers_2017_4_196 = self.intel-compilers "2017.4.196" "/opt/intel/compilers_and_libraries_2017.4.196/linux";
    intel-compilers_2017 = self.intel-compilers_2017_4_196;
    intel-compilers_2017_5_239 = self.intel-compilers "2017.5.239" "/opt/intel/compilers_and_libraries_2017.5.239/linux";

    intel-compilers_2018_0_128 = self.intel-compilers "2018.0.128" "/opt/intel/compilers_and_libraries_2018.0.128/linux";
    intel-compilers_2018_1_163 = self.intel-compilers "2018.1.163" "/opt/intel/compilers_and_libraries_2018.1.163/linux";
    intel-compilers_2018_2_199 = self.intel-compilers "2018.2.199" "/opt/intel/compilers_and_libraries_2018.2.199/linux";
    intel-compilers_2018 = self.intel-compilers_2018_2_199;

    stdenvIntel = self.intel-compilers_2017.stdenv;
}
