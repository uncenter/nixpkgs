{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  perl,
  zlib,
  bzip2,
}:

stdenv.mkDerivation rec {
  pname = "routino";
  version = "3.4.3";

  src = fetchurl {
    url = "https://routino.org/download/routino-${version}.tgz";
    hash = "sha256-TroGfTLJfKk4itbpfA9aPBDUiCk2ckDXjFE3XYzBHlQ=";
  };

  patchFlags = [ "-p0" ];
  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/18fd229516a46e7272003acbe555735b2a902db7/gis/routino/files/patch-Makefile_conf.diff";
      sha256 = "1b7hpa4sizansnwwxq1c031nxwdwh71pg08jl9z9apiab8pjsn53";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/18fd229516a46e7272003acbe555735b2a902db7/gis/routino/files/patch-src_Makefile_dylib_extension.diff";
      sha256 = "1kigxcfr7977baxdsfvrw6q453cpqlzqakhj7av2agxkcvwyilpv";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.conf \
      --subst-var-by PREFIX $out
  '';

  nativeBuildInputs = [ perl ];

  buildInputs = [
    zlib
    bzip2
  ];

  outputs = [
    "out"
    "doc"
  ];

  CLANG = lib.optionalString stdenv.cc.isClang "1";

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "http://www.routino.org/";
    changelog = "http://routino.org/software/NEWS.txt";
    description = "OpenStreetMap Routing Software";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux ++ darwin;
  };
}
