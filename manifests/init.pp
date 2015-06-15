# Installs Facebook Infer

# Examples
#
#    include infer

class infer {
  $home = "/Users/${::boxen_user}"
  $filename = "infer-osx-v0.1.0.tar.xz"
  $download_url = "https://github.com/facebook/infer/releases/download/v0.1.0/${filename}"
  $rc_file = "${home}/.zshrc"
  $bin_path = "${home}/bin/infer-osx-v0.1.0/infer/infer/bin"

  file { "${home}/bin":
    ensure => directory
  }

  exec { "Download Infer":
    command => "wget ${download_url}",
    cwd => "/tmp",
    creates => "/tmp/${filename}",
    require => File["${home}/bin"]
  }

  exec { "Unpack Infer":
    command => "tar -xjf ${filename} -C ${home}/bin/",
    cwd => "/tmp",
    require => Exec["Download Infer"],
    path => "/bin:/usr/bin",
    creates => "${bin_path}/infer"
  }

  exec { "Add Infer to path":
    command => "echo 'export PATH=\"\$PATH:${bin_path}\"' >> ${rc_file}",
    unless => "grep -qe '^export PATH=\"$PATH:${bin_path}\"' -- ${rc_file}",
    path => "/bin:/usr/bin",
    require => Exec["Unpack Infer"]
  }
}
