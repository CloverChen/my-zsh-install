#!/bin/sh

# 安装 homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 安装 zsh git gsed wget

brew install zsh git gsed wget

wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
gsed -i 's/exec zsh.*//g' install.sh
chmod +x install.sh
./install.sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
gsed -i 's/^ZSH_THEME.*/ZSH_THEME="ys"/g' ~/.zshrc
gsed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions extract z history-substring-search)/g' ~/.zshrc
echo "bindkey ';' autosuggest-accept" >> ~/.zshrc
exec zsh -l
