{ mkDerivation, base, bytestring, lib, network }:
mkDerivation {
  pname = "http-server-haskell";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network ];
  description = "smalll http server";
  license = lib.licensesSpdx."BSD-3-Clause";
  mainProgram = "http-server-haskell";
}
