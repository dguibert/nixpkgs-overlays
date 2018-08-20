{stdenv, fetchurl, lib}:
with lib;
let
  version = "2.10";

  hello = stdenv.mkDerivation rec {
    name = "hello-${version}";
    inherit version;
  
    src = fetchurl {
      url = "mirror://gnu/hello/${name}.tar.gz";
      sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
    };
  
    doCheck = true;
  
    meta = with stdenv.lib; {
      description = "A program that produces a familiar, friendly greeting";
      longDescription = ''
        GNU Hello is a program that prints "Hello, world!" when you run it.
        It is fully customizable.
      '';
      homepage = http://www.gnu.org/software/hello/manual/;
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.eelco ];
      platforms = platforms.all;
    };
  };

  tests = { 
    helloTest = ''
      ${hello}/bin/hello \
        | grep "Hello, world!"
    '';
    versionText = ''
      ${hello}/bin/hello --version \
        | grep "${version}"
    '';
  };

in withTests tests hello
#in hello
