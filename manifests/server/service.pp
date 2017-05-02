# = Class: sensu::server::service
#
# Manages the Sensu server service
#
# == Parameters
#
# [*hasrestart*]
#   Boolean. Value of hasrestart attribute for this service.
#   Default: true

class sensu::server::service (
  $hasrestart = true,
) {

  validate_bool($hasrestart)

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $sensu::manage_services {

    case $sensu::server {
      true: {
        $ensure = 'running'
        $enable = true
      }
      default: {
        $ensure = 'stopped'
        $enable = false
      }
    }

    if $::osfamily != 'windows' {
      case $::operatingsystem {
        /Debian/: {
          if $::operatingsystem == 'Ubuntu' and $::operatingsystemmajrelease >= '15.10'{
            service { 'sensu-server':
              ensure     => $ensure,
              provider   => systemd,
              enable     => $enable,
              hasrestart => $hasrestart,
              subscribe  => [ Class['sensu::package'], Class['sensu::api::config'], Class['sensu::redis::config'], Class['sensu::rabbitmq::config'] ],
            }
          } else {
            service { 'sensu-server':
              ensure     => $ensure,
              enable     => $enable,
              hasrestart => $hasrestart,
              subscribe  => [ Class['sensu::package'], Class['sensu::api::config'], Class['sensu::redis::config'], Class['sensu::rabbitmq::config'] ],
            }
          } 
        } 
        default: {
          service { 'sensu-server':
            ensure     => $ensure,
            enable     => $enable,
            hasrestart => $hasrestart,
            subscribe  => [ Class['sensu::package'], Class['sensu::api::config'], Class['sensu::redis::config'], Class['sensu::rabbitmq::config'] ],
          }
        }
      }
    }
  }
}


#      service { 'sensu-server':
#        ensure     => $ensure,
#        enable     => $enable,
#        hasrestart => $hasrestart,
#        subscribe  => [ Class['sensu::package'], Class['sensu::api::config'], Class['sensu::redis::config'], Class['sensu::rabbitmq::config'] ],
      