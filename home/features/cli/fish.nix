{ config, pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # if status is-interactive
      #   bash -c "nohup VBoxManage startvm 6201-mc --type headless > /dev/null 2>&1  || true" &; disown
      # end
    '';
    plugins = [ ];
  };
}
