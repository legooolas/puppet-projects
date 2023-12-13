# == Class: projects
#
# A puppet module to manage top level projects.
#
# === Examples
#
# === Authors
#
# Dan Foster <dan@zem.org.uk>
#
# === Copyright
#
# Copyright 2015 Dan Foster, unless otherwise noted.
#
class projects (
  $basedir = '/srv/projects',
  $symlink = [],
  $projects,
) inherits ::projects::params {

  file { $basedir:
    ensure => directory,
    mode   => '0775',
    owner  => root,
    group  => root,
  }

  file { $symlink:
    ensure => symlink,
    target => $basedir,
  }

  $webuser = lookup('projects::webuser', Enum['apache', 'www-data'], first, 'apache')

  file { '/usr/local/bin/reset-perms':
    source  => epp('projects/bin/reset-perms.epp', {
      webuser => $webuser,
      }),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  create_resources('projects::project', $projects)
}
