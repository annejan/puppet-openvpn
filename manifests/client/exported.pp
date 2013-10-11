#
# The $server parameter is unused here, but can be used for filtering exported resources
#
define openvpn::client::exported (
  $cn,
  $instance,
  $push         = '',
  $pushReset    = false,
  $iroute       = '',
  $ifconfigPush = '',
  $config       = '',
  $server       = $::fqdn,
) {

  file { "${openvpn::config_dir}/${instance}/ccd/${cn}":
    ensure  => file,
    mode    => $openvpn::config_file_mode,
    owner   => $openvpn::config_file_owner,
    group   => $openvpn::config_file_group,
    content => template('openvpn/ccd.conf.erb'),
    require => File[ "${openvpn::config_dir}/${instance}/ccd" ]
  }

  exec { "openvpn-client-gen-cert-${name}":
    command  => ". ./vars && KEY_CN=${cn} ./pkitool ${cn}",
    cwd      => "${openvpn::config_dir}/${instance}/easy-rsa",
    creates  => "${openvpn::config_dir}/${instance}/easy-rsa/keys/${cn}.crt",
    provider => 'shell',
    notify   => Service['openvpn'],
    require  => Exec["openvpn-tunnel-rsa-ca-${instance}"]
  }

}