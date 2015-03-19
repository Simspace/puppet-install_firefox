class install_firefox (
  $installer = $install_firefox::params::installer,
) inherits install_firefox::params {
  include staging

  if $::operatingsystem == 'windows' {

    $exe = inline_template('<%= File.basename(@installer) %>')

    acl { "${staging_windir}/install_firefox/${exe}":
      purge => false,
      permissions => [ { identity => 'Administrators', rights => ['full'] },],
      }

      staging::file { $exe:
        source => $installer,
        }


        package { 'Firefox':
          ensure => installed,
          source => "${staging_windir}\\install_firefox\\${exe}",
          require => [ Staging::File[$exe], Acl["${staging_windir}/install_firefox/${exe}"] ],
          install_options => '-ms',
          }
  }
}
