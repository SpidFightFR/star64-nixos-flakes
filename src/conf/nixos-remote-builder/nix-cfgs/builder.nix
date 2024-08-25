{ config, pkgs, ... }:

{
  boot.binfmt.emulatedSystems = [ "riscv64-linux" ]; #required in order to build from x86_64 to riscv64

  #builder config
  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "localhost";
      protocol = "ssh-ng";
      systems = ["x86_64-linux" "riscv64-linux"];
      maxJobs = 12;  # number of jobs allowed, base this number around nproc output
      speedFactor = 2;
      supportedFeatures = [ "kvm" "big-parallel" ];
    }];
  };
}
