# ------------------------------------------------------------------------------
# Description
# -----------
#
# 添加一些常用的功能
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * 应卓 <github.com/yingzhuo>
#
# ------------------------------------------------------------------------------

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
  sudo \yum clean packages
}

function __clean_ubuntu() {
  sudo \apt-get autoremove -y
}

function __update_ntp() {
  sudo hwclock --hctosys
  sudo ntpdate -u cn.pool.ntp.org
}

case $(__os) {
  "CentOS")
    alias sys.reboot=__reboot
    alias sys.shutdown=__shutdown
    alias sys.update=__update_centos
    alias sys.clean=__clean_centos
    alias sys.ntp=__update_ntp
    ;;
  "Ubuntu")
    alias sys.reboot=__reboot
    alais sys.shutdown=__shutdown
    alias sys.update=__update_ubuntu
    alias sys.clean=__clean_ubuntu
    alias sys.ntp=__update_ntp
    ;;
  *)
  ;;
}
