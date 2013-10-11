#
# This type is defined and exported from an openvpn server instance to its clients
# It is used to transfer settings from the server to the client.
#
define openvpn::client::config (
  $server,
  $instance,
  $port,
  $proto,
  $dev,
  $auth_type,
  $route,
) {
  
  $real_proto = $proto ? {
    udp => 'udp',
    tcp => 'tcp-client'
  }

  file { "${openvpn::config_dir}/${server}-${instance}.conf":
    ensure  => present,
    content => template('openvpn/client.conf.erb'),
    mode    => $openvpn::config_file_mode,
    owner   => $openvpn::config_file_owner,
    group   => $openvpn::config_file_group,
    require => Package['openvpn'],
  }
}
