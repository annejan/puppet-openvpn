
define openvpn::client (
  $instance,
  $server,
) {
  
  include openvpn

  @@openvpn::client::exported { "$name":
    cn        => $::fqdn,
    instance  => $instance,
    server    => $server,
  }

  Openvpn::Client::Config <<| server == $server and instance == $instance |>> {
    
  }
  
}
