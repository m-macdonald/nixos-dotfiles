{pkgs, ...}: {
  isNormalUser = true;
  groups = ["input" "wheel" "podman" "optical" "cdrom"];
  shell = pkgs.zsh;
  uid = 1000;
  isAllowedNix = true;
}
