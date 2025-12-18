
## Linting, code style

Для форматирования кода в соответствии с соглашением о коде [pre-commit](https://pre-commit.com/) используется пакет:

```shell
pip install pre-commit
pre-commit install
```

### VHDL

Используй плагин для VSCode:

* [VHDL LS](https://marketplace.visualstudio.com/items?itemName=hbohlin.vhdl-ls)

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

### System Verilog

Code style is based on [lowRISC style-guides](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)

#### Для линтинга

Используй плагин для VSCode:

* [VerilogHDL](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL)

Внутри плагина VerilogHDL используется [Verilator](https://verilator.org/guide/latest/install.html#package-manager-quick-install)

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

#### Для форматирования

Для форматирования через pre-commit потребуется поставить [Verible](https://github.com/chipsalliance/verible)

* Download [Verible](https://github.com/chipsalliance/verible/releases)
* Unpack and add to PATH
