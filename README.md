# Моя конфигурация NixOS

## Быстрый старт

1. Клонируйте репозиторий и перейдите в каталог:

    ```bash
    git clone git@github.com:Daniil11ru/nix-configuration.git nixos-configuration
    cd nixos-configuration
    ```

1. При необходимости замените имя пользователя (`nixos` по умолчанию);

1. Примените конфигурацию:

   ```bash
   sudo nixos-rebuild switch --flake .#wsl
   ```

## Дополнительные окружения

Активация:

```bash
cd projects/<project>
nix develop
```

Выход:

```bash
exit
```

## Обновление версий входов

```bash
nix flake update
```

## TODO

1. Добавить tabiview, timr-tui.
