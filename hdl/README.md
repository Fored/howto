# Библиотека общего кода

## Linting

### VHDL
Используй плагин для VSCode:

* [VHDL LS](https://marketplace.visualstudio.com/items?itemName=hbohlin.vhdl-ls)

### System Verilog

Использовать [Verilator](https://verilator.org/guide/latest/install.html#package-manager-quick-install)

  ```shell
    sudo apt-get install verilator   # On Ubuntu
    sudo dnf install verilator verilator-devel # On Fedora
  ```

Add to .vscode/settings.json

```text
  "verilog.linting.linter": "verilator",
  "verilog.linting.verilator.arguments": "-I<Path to Vivado>/data/verilog/src/xeclib -F ./.verilator_args",
  "verilog.ctags.path": "/usr/bin/ctags"
```

## Repository code style

Весь код, который коммитится в репозитории, должен быть пропущен через автоформатер:

### Для VHDL используется [vhdl-style-guide](https://github.com/jeremiah-c-leary/vhdl-style-guide)

Для автоформатирования поставить плагин выполнения команд при сохранении:

* [RunOnSave](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave)

Поставить vsg

```shell
sudo dnf install pipx
pipx install vsg
```

Add to .vscode/settings.json

```text
"emeraldwalk.runonsave": {
      "commands": [
        {
          "match": "\\.vhd$|\\.vhdl$",
          "cmd": "echo '${file}' | xargs -I {} vsg -f \"{}\" --fix --configuration=.vhdl-style.yaml"
        }
      ]
  }
```

