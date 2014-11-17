# == Class: hiera::eyaml
#
# This class installs and configures hiera-eyaml
#
# === Authors:
#
# Terri Haber <terri@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera::eyaml { 
  package { 'hiera-eyaml':
    ensure   => installed,
    provider => $hiera::provider,
  }

  file { "${hiera::confdir}/keys":
    ensure => directory,
    owner  => $hiera::owner,
    group  => $hiera::group,
    before => Exec['createkeys'],
  }

  exec { 'createkeys':
    user    => $hiera::owner,
    cwd     => $hiera::confdir,
    command => 'eyaml createkeys',
    path    => $hiera::cmdpath,
    creates => "${hiera::confdir}/keys/private_key.pkcs7.pem",
    require => Package['hiera-eyaml'],
  }

  $eyaml_files = [
    "${hiera::confdir}/keys/private_key.pkcs7.pem",
    "${hiera::confdir}/keys/public_key.pkcs7.pem"]

  file { $eyaml_files:
    ensure  => file,
    mode    => '0604',
    owner   => $hiera::owner,
    group   => $hiera::group,
    require => Exec['createkeys'],
  }
}
