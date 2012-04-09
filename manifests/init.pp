class dnsmasq (
  $version = 'installed',
  $active = true,
  $init_config = false
  ) {

  package { 'dnsmasq':
    ensure => $version,
  }

  if $init_config {
    sysvinit::init::config { 'dnsmasq':
      changes => $init_config,
    }
  }

  service { 'dnsmasq':
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    require => Package['dnsmasq'],
  }
}

define dnsmasq::config (
  $content,
  $order = 20
  ) {
  file { "/etc/dnsmasq.d/${order}-${name}":
    content => $content,
    require => Package['dnsmasq'],
    notify => Service['dnsmasq'],
  }
}
