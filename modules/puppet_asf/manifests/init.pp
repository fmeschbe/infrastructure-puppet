class puppet_asf (
  $puppetconf  = '/etc/puppet/puppet.conf'
){

  case $asfosname { 
    ubuntu: {
      package { 'puppet':
        ensure  => '3.7.4-1puppetlabs1',
        require => Apt::Source['puppetlabs', 'puppetdeps'],
      }
    }
    centos: {
      package { 'puppet':
        ensure  => '3.7.4-1.el6',
        require => Yumrepo['puppetlabs-products', 'puppetlabs-deps'],
      }
    }
    default: {
    }
  }

  service { 'puppet':
    require => Package['puppet'],
    hasstatus => true,
    hasrestart => true,
    enable => true,
    ensure => running,
  }

 file { "${puppetconf}" :
   ensure  => present,
   require => Package["puppet"],
   notify  => Service["puppet"],
   owner   => 'root',
   group   => 'puppet',
   mode    => '0755',
   source  => [ 
     "puppet:///modules/puppet_asf/puppet.$hostname.conf",
     "puppet:///modules/puppet_asf/$asfosname.puppet.conf",
     "puppet:///modules/puppet_asf/puppet.conf",
     ]
  }

}
