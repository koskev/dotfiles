{
  pkgs,
  lib,
  kernelModuleMakeFlags,
  kernel ? pkgs.linuxPackages_latest.kernel,
}:
let
  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in

pkgs.stdenv.mkDerivation {
  pname = "amdgpu-kernel-module";
  inherit (kernel)
    src
    version
    postPatch
    nativeBuildInputs
    ;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  modulePath = "drivers/gpu/drm/amd/amdgpu";

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${KDIR}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=updates"
  ];

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installTargets = [ "modules_install" ];
  installFlags = [
    "-C"
    "${KDIR}"
    "M=$(PWD)"
  ];

  meta = {
    description = "AMD GPU kernel module";
    license = lib.licenses.gpl3;
  };
}
