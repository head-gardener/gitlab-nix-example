test-init:
  nixos-container create gitlab-dev --flake .#gitlab-dev 
  echo -e '[Service]\nTimeoutStartSec=5min' | EDITOR='tee' systemctl edit --runtime container@gitlab-dev.service

test-restart:
  nixos-container update gitlab-dev --flake .#gitlab-dev 

test-start:
  nixos-container start gitlab-dev

test-login:
  nixos-container root-login gitlab-dev

test-stop:
  nixos-container stop gitlab-dev

test-destroy:
  nixos-container destroy gitlab-dev
