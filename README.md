# Моя конфигурация NixOS

## Быстрый старт

1. Установите Home Manager:

    ```bash
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
    nix-channel --update
    ```

1. Установите Git во временную оболочку:

    ```bash
    nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#git
    ```

1. Клонируйте репозиторий и перейдите в каталог:

    ```bash
    git clone git@github.com:Daniil11ru/nix-configuration.git nixos-configuration
    cd nixos-configuration
    ```

1. Скопируйте ключ:

    ```bash
    mkdir -p ~/.config/sops/age
    cp <path-to-age-key-file> ~/.config/sops/age/keys.txt
    ```

1. Примените конфигурацию:

   ```bash
   sudo nixos-rebuild switch --flake .#wsl
   ```

1. Выйдите из временной оболочки:

    ```bash
    exit
    ```

## Обновление версий входов

```bash
nix flake update
```

## TODO

1. Добавить tabiview;
1. Добавить timr-tui.
