# ----------------------------------------------------------------------------------------------------------------------
# Description
# -----------
#
# 添加一些常用的功能和命令别名
#
# ----------------------------------------------------------------------------------------------------------------------
# Authors
# -------
#
# * 应卓 <github.com/yingzhuo>
#
# ----------------------------------------------------------------------------------------------------------------------

alias type='type -a'

alias c='clear'
alias cls='clear'

alias vi='vim'
alias edit='vim'
alias emacs='vim'
alias nano='vim'

alias date='/bin/date "+%F %T"'
alias timestamp='/bin/date +%s'

alias more='less'

alias ping='ping -c 5'

alias shutdown='false'
alias halt='false'
alias reboot='false'
alias poweroff='false'

alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias sysctl='sudo sysctl'
alias systemctl='sudo systemctl'

alias q='exit'

if [[ $EUID -eq -0 ]]; then
    alias root='true'
else
    alias root='su -'
fi

# ----------------------------------------------------------------------------------------------------------------------

# Editor
export EDITOR='vim'

# Time Style
export TIME_STYLE=long-iso

# Locale
export LC_ALL=en_US.UTF-8

# GPG
export GPG_TTY=$(tty)

# History
export HISTSIZE=1500
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000
export HISTCONTROL=ignoreboth

# bin / sbin
[[ -d $HOME/bin ]] && export PATH=$PATH:$HOME/bin
[[ -d $HOME/sbin ]] && export PATH=$PATH:$HOME/sbin

# 其他
export PATH=.:$PATH

# ----------------------------------------------------------------------------------------------------------------------

function __os() {
  lsb_release -d | awk '{print $2}'
}

function __update_centos() {
  sudo \yum -y update
  sudo \yum clean packages
}

function __update_ubuntu() {
  sudo \apt-get update -y
  sudo \apt-get upgrade -y
  sudo \apt-get dist-upgrade -y
  sudo \apt-get autoremove -y
}

function __reboot() {
  sudo \reboot now
}

function __shutdown() {
  sudo \shutdown now
}

function __clean_centos() {
  sudo \yum clean packages &> /dev/null
}

function __clean_ubuntu() {
  sudo \apt-get autoremove -y &> /dev/null
}

function __deep_clean_centos() {
  sudo \yum clean all &> /dev/null
  sudo \rm -rf /var/cache/yum &> /dev/null || true
  sudo \rm -rf /var/cache/dnf &> /dev/null || true
  sudo \rm -rf /var/log/* &> /dev/null || true
  sudo \rm -rf /tmp/* &> /dev/null || true
  sudo history -c &> /dev/null && history -c &> /dev/null &> /dev/null
}

function __deep_clean_ubuntu() {
  sudo \apt-get autoremove -y
  sudo \rm -rf /var/cache/apt/* &> /dev/null || true
  sudo \rm -rf /var/log/* &> /dev/null || true
  sudo \rm -rf /tmp/* &> /dev/null || true
  sudo history -c &> /dev/null && history -c &> /dev/null &> /dev/null
}

function __update_ntp() {
  sudo hwclock --hctosys
  sudo ntpdate -u cn.pool.ntp.org
}

case $(__os) {
  "CentOS")
    # ---
    alias sys.ntp=__update_ntp
    alias sys.reboot=__reboot
    alias sys.shutdown=__shutdown
    alias sys.update=__update_centos
    alias sys.clean=__clean_centos
    alias sys.deep-clean=__deep_clean_centos
    # ---
    alias yum='sudo yum'
    alias dnf='sudo dnf'
    ;;

  "Ubuntu")
    alias sys.ntp=__update_ntp
    alias sys.reboot=__reboot
    alias sys.shutdown=__shutdown
    alias sys.update=__update_ubuntu
    alias sys.clean=__clean_ubuntu
    alias sys.deep-clean=__deep_clean_ubuntu
    # ---
    alias apt-get='sudo apt-get'
    alias apt='sudo apt'
    ;;
  *)
  ;;
}
