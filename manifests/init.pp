# Copyright 2014 Martin Schulze
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Class: xfce
#
# This module manages xfce
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class xfce (
) {

  Exec[ 'update-package-sources' ] -> Package <| |>

  $package_list = ['lightdm',
                   'lightdm-gtk3-greeter',
                   'xorg-xinit',
                   'exo',
                   'garcon',
                   'gtk2-xfce-engine',
                   'gtk3-xfce-engine',
                   'thunar',
                   'thunar-volman',
                   'tumbler',
                   'xfce4-appfinder',
                   'xfce4-mixer',
                   'xfce4-panel',
                   'xfce4-power-manager',
                   'xfce4-session',
                   'xfce4-settings',
                   'xfce4-terminal',
                   'xfconf',
                   'xfdesktop',
                   'xfwm4',
                   'xfwm4-themes',

                   'mousepad',
                   'orage',
                   'viewnior',
                   'thunar-archive-plugin',
                   'thunar-media-tags-plugin',
                   'xfburn',
                   'xfce4-artwork',
                   'xfce4-battery-plugin',
                   'xfce4-clipman-plugin',
                   'xfce4-cpufreq-plugin',
                   'xfce4-cpugraph-plugin',
                   'xfce4-datetime-plugin',
                   'xfce4-dict',
                   'xfce4-diskperf-plugin',
                   'xfce4-eyes-plugin',
                   'xfce4-fsguard-plugin',
                   'xfce4-genmon-plugin',
                   'xfce4-mailwatch-plugin',
                   'xfce4-mount-plugin',
                   'xfce4-mpc-plugin',
                   'xfce4-netload-plugin',
                   'xfce4-notes-plugin',
                   'xfce4-notifyd',
                   'xfce4-quicklauncher-plugin',
                   'xfce4-screenshooter',
                   'xfce4-sensors-plugin',
                   'xfce4-smartbookmark-plugin',
                   'xfce4-systemload-plugin',
                   'xfce4-taskmanager',
                   'xfce4-time-out-plugin',
                   'xfce4-timer-plugin',
                   'xfce4-verve-plugin',
                   'xfce4-wavelan-plugin',
                   'xfce4-weather-plugin',
                   'xfce4-xkb-plugin',
                   'ttf-droid'
                  ]

  package { $xfce::package_list:
    ensure => present,
  }


  exec { '/usr/bin/systemctl enable lightdm.service':
    require  => Package [ $xfce::package_list ],
    unless   => '/usr/bin/systemctl is-active lightdm.service',
  }

  file { '/home/vagrant/.xinitrc':
    source => "/etc/skel/.xinitrc",
    owner  => vagrant,
    group  => vagrant,
    require  => Package [ $xfce::package_list ],
  }

  file { '/home/vagrant/.themes':
    ensure => directory,
    owner => vagrant,
    group  => vagrant,
    require  => Package [ $xfce::package_list ],
  }

  file { '/home/vagrant/.fonts':
    ensure => directory,
    owner => vagrant,
    group  => vagrant,
  }

  file { '/home/vagrant/.themes/NumixBlack':
    source  => "/vagrant/data/xfce/NumixBlack",
    recurse => true,
    require => [ File[ '/home/vagrant/.themes' ], ],
  }

  file { '/home/vagrant/.themes/BSMSimplePanelDark':
    source  => "/vagrant/data/xfce/BSMSimplePanelDark",
    recurse => true,
    require => [ File[ '/home/vagrant/.themes' ], ],
  }

  file { "/home/vagrant/.config/":
    ensure => directory,
    force  => false,
    owner  => vagrant,
    group  => vagrant,
  }

  file { '/home/vagrant/.config/xfce4/':
    source  => "/vagrant/data/xfce/xfce4",
    require => File [ "/home/vagrant/.config/" ],
    recurse => true,
    owner   => vagrant,
    group   => vagrant,
  }

  file { '/home/vagrant/.fonts/titillium':
    source  => "/vagrant/data/xfce/titillium",
    recurse => true,
    require => [ File[ '/home/vagrant/.fonts' ], ],
    owner => vagrant,
    group => vagrant,
  }

  $lightdm_conf_file = '/etc/lightdm/lightdm.conf'

  file { 'lightdm.conf':
    path   => "${xfce::lightdm_conf_file}",
    content=>template("xfce/lightdm.conf.erb"),
    require  => Package [ $xfce::package_list ],
  }

  group { "autologin":
    ensure => present,
  }

  exec {"vagrant autologin membership":
    unless => "/usr/bin/grep -q 'autologin\\S*foo' /etc/group",
    command => "/usr/bin/usermod -aG autologin vagrant",
    require => Group [ "autologin" ],
  }
}
