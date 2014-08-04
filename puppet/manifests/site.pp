# define your required node configuration via puppet here
#
stage { "pre":
  before => Stage["main"],
}

class { 'debian_base':
  stage => "pre",
}

class { 'java':
  distribution => 'jre',
  before       => [
    Class['elasticsearch'],
    Class['graylog2::server'],
    Class['graylog2::web']
  ],
}

class { 'elasticsearch':
  cluster_name => 'graylog2',
  repo_baseurl => 'http://packages.elasticsearch.org/elasticsearch/0.90/debian',
  before       => [
    Class['graylog2::server'],
    Class['graylog2::web']
  ],
}

class { 'mongodb':
  before => [
    Class['graylog2::server'],
    Class['graylog2::web']
  ],
}

class { 'graylog2::repo': } ->
class { 'graylog2::server':
  root_username      => 'admin',
  root_password_sha2 => '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', # admin
  password_secret    => 'You MUST set a secret to secure/pepper the stored user passwords here. Use at least 64 characters',
  rest_listen_uri    => 'http://127.0.0.1:12900/',
  rest_transport_uri => 'http://127.0.0.1:12900/',
} ->
class { 'graylog2::web':
  application_secret   => 'You MUST set a secret to secure/pepper the stored user passwords here. Use at least 64 characters',
  graylog2_server_uris => ["http://127.0.0.1:12900/"],
}

class { 'apache':
  default_vhost     => false,
  default_ssl_vhost => false,
}

apache::vhost { 'graylog2':
  port          => 80,
  docroot       => '/var/www/html',
  vhost_name    => '*',
  default_vhost => true,
  rewrites      => [{
      rewrite_cond => ['%{SERVER_PORT} !^443$'],
      rewrite_rule => ['^/(.*) https://%{HTTP_HOST}/$1 [NC,R,L]']
  }],
}

apache::vhost { 'graylog2-ssl':
  port       => 443,
  docroot    => '/var/www/html',
  vhost_name => '*',
  ssl        => true,
  proxy_pass => [{
      'path' => '/',
      'url'  => 'http://0.0.0.0:9000/'
  }],
}
