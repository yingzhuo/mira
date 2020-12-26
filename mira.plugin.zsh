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
alias chmod='sudo chmod'
alias chown='sudo chown'

alias q='exit'

if [[ $EUID -eq -0 ]]; then
    alias root='true'
else
    alias root='sudo -i'
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
  sudo hwclock --hctosys
  sudo \yum -y update
  sudo \yum clean packages
}

function __update_ubuntu() {
  sudo hwclock --hctosys
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

function __empty_dir() {
  sudo find $1 \
    -mindepth 1 -maxdepth 1 -type f -exec rm -rv {} + -o \
    -mindepth 1 -maxdepth 1 -type d -exec rm -rv {} + &> /dev/null
}

function __deep_clean_common() {
  for homedir in $(getent passwd | cut -d: -f6 | sort | uniq)
  do
    if [[ -d $homedir ]]
    then
      [[ -e "$homedir/.cache" ]] && sudo rm -rf $homedir/.cache
      [[ -e "$homedir/.viminfo" ]] && sudo rm -rf $homedir/.viminfo
      [[ -e "$homedir/.beeline" ]] && sudo rm -rf $homedir/.beeline
      [[ -e "$homedir/.selected_editor" ]] && sudo rm -rf $homedir/.selected_editor
      [[ -e "$homedir/.sudo_as_admin_successful" ]] && sudo rm -rf $homedir/.sudo_as_admin_successful
      sudo find $homedir -type f -name '.zcompdump*' -delete
      sudo find $homedir -maxdepth 1 -type f -name '*history' -delete
    fi
  done

  $(__empty_dir /var/log)
  $(__empty_dir /tmp)
  sudo history -c &> /dev/null && history -c &> /dev/null || true
}

function __deep_clean_centos() {
  sudo \yum clean all &> /dev/null
  $(__deep_clean_common)
}

function __deep_clean_ubuntu() {
  sudo \apt-get autoremove -y &> /dev/null
  $(__empty_dir /var/cache/apt)
  $(__deep_clean_common)
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
