{ mkDerivation, base, lib }:
mkDerivation {
  pname = "http-server-haskell";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  description = "smalll http server";
  license = lib.licensesSpdx."BSD-3-Clause";
  mainProgram = "http-server-haskell";
}
