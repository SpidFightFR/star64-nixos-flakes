{ config, pkgs, modulesPath, inputs, ... }:

{
  nix = {
    distributedBuilds = true;
    buildMachines = [{
      hostName = "<Ip_Remote_Builder>";  # Remplacez par l'adresse IP ou le nom d'hôte de votre PC Builder
      systems = ["x86_64-linux" "riscv64-linux"];
      maxJobs = 12; #Number of packages that can be compiled at the same time. Set this accordingly to $(nproc) and your amount of ram.
      speedFactor = 2;
      supportedFeatures = [ "kvm" "big-parallel" ];
      sshUser = "<remote_builder_nix_user>";
      sshKey = "<remote_builder_SSH_login_key>";
    }];
  };

}
