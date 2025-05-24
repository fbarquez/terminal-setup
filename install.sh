echo " This script is not meant to be run on this system yet. Exiting..."
exit 1


#!/bin/bash

echo ""
echo "==========[ Terminal Setup Installer ]=========="
echo ""

# 1. Requisitos del sistema
echo "[*] Installing required packages..."
sudo apt update && sudo apt install -y zsh git curl jq boxes fonts-powerline

# 2. Copiar archivos de configuración
echo "[*] Copying config files to home..."
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
cp .terminal_log ~/.terminal_log 2>/dev/null || touch ~/.terminal_log

# 3. Configurar Zsh como shell por defecto
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "[*] Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
else
  echo "[✓] Zsh is already the default shell."
fi

# 4. Clonar fuente Powerlevel10k si no existe
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "[*] Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# 5. Recordatorio
echo ""
echo "⚡ DONE! Please restart your terminal or run: zsh"
echo "➡  To re-run the terminal intro, type: source ~/.zshrc"
echo ""
