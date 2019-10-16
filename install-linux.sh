#!/bin/sh

app_cmd="apt-get"

check_cmd_exist() {
	# 返回0时，命令存在
	type $1 >/dev/null 2>&1
	if [ "$?" -ne 0 ]; then
		return "1"
	else
		return "0"
	fi
}

install_app() {
	local install_shell="sudo $app_cmd install $1 -y"
	eval $install_shell
}

check_and_install() {
	local name=""
	check_cmd_exist "$1"
	if [ "$?" -ne 0 ]; then
		if [ ! -n "$2" ]; then
			name=$1
		else
			name=$2
		fi
		echo "检测到未安装$name，正在尝试安装$name"
		install_app "$name"
	fi 
	
}

install_init() {
	check_cmd_exist "apt-get"
	if [ "$?" -ne 0 ]; then
		check_cmd_exist "yum"
		if [ "$?" -ne 0 ]; then
			echo "此脚本无法在此设备上运行"
			exit 1
		else
			app_cmd="yum"
		fi
	fi
	check_and_install "git"
	check_and_install "zsh"
	check_and_install "wget"
}

install_init
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sed -i 's/exec zsh.*//g' install.sh
chmod +x install.sh
./install.sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
sed -i 's/^ZSH_THEME.*/ZSH_THEME="ys"/g' ~/.zshrc
sed -i 's/^plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions extract z history-substring-search)/g' ~/.zshrc
echo "bindkey ';' autosuggest-accept" >> ~/.zshrc
exec zsh -l
