# Class: java::params
#
# This class builds a hash of JDK/JRE packages and (for Debian)
# alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
# options, even though those are not in the package repositories.
#
# For more info on how to package Oracle JDK/JRE, see the Debian wiki:
# http://wiki.debian.org/JavaPackage
#
# Because the alternatives system makes it very difficult to tell
# which Java alternative is enabled, we hard code the path to bin/java
# for the config class to test if it is enabled.
class java::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL': {
          if (versioncmp($::operatingsystemrelease, '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
            $java_home   = '/usr/lib/jvm/java-1.6.0-sun/jre/'
          }
          elsif (versioncmp($::operatingsystemrelease, '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
            $java_home   = "/usr/lib/jvm/java-1.6.0-openjdk-${::architecture}/"
          }
          elsif (versioncmp($::operatingsystemrelease, '7.1') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
            $java_home   = "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/"
          }
          else {
            $jdk_package = 'java-1.8.0-openjdk-devel'
            $jre_package = 'java-1.8.0-openjdk'
            $java_home   = "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/"
          }
        }
        'Fedora': {
          if (versioncmp($::operatingsystemrelease, '21') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
            $java_home   = "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/"
          }
          else {
            $jdk_package = 'java-1.8.0-openjdk-devel'
            $jre_package = 'java-1.8.0-openjdk'
            $java_home   = "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/"
          }
        }
        'Amazon': {
          $jdk_package = 'java-1.7.0-openjdk-devel'
          $jre_package = 'java-1.7.0-openjdk'
          $java_home   = "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/"
        }
        default: { fail("unsupported os ${::operatingsystem}") }
      }
      $java = {
        'jdk' => {
          'package'   => $jdk_package,
          'java_home' => $java_home,
        },
        'jre' => {
          'package'   => $jre_package,
          'java_home' => $java_home,
        },
      }
    }
    'Debian': {
      $oracle_architecture = $::architecture ? {
        'amd64' => 'x64',
        default => $::architecture
      }
      case $::lsbdistcodename {
        'lenny', 'squeeze', 'lucid', 'natty': {
          $java  = {
            'jdk' => {
              'package'          => 'openjdk-6-jdk',
              'alternative'      => "java-6-openjdk-${::architecture}",
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-openjdk/jre/',
            },
            'jre' => {
              'package'          => 'openjdk-6-jre-headless',
              'alternative'      => "java-6-openjdk-${::architecture}",
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-openjdk/jre/',
            },
            'sun-jre' => {
              'package'          => 'sun-java6-jre',
              'alternative'      => 'java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-sun/jre/',
            },
            'sun-jdk' => {
              'package'          => 'sun-java6-jdk',
              'alternative'      => 'java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-sun/jre/',
            },
          }
        }
        'wheezy', 'jessie', 'quantal', 'raring', 'saucy', 'utopic': {
	  $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jdk7' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jre7' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'oracle-jre' => {
              'package'          => 'oracle-j2re1.7',
              'alternative'      => 'j2re1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.7-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.7-oracle/',
            },
            'oracle-jdk' => {
              'package'          => 'oracle-j2sdk1.7',
              'alternative'      => 'j2sdk1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.7-oracle/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.7-oracle/jre/',
            },
            'oracle-j2re' => {
              'package'          => 'oracle-j2re1.8',
              'alternative'      => 'j2re1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.8-oracle/',
            },
            'oracle-j2sdk' => {
              'package'          => 'oracle-j2sdk1.8',
              'alternative'      => 'j2sdk1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.8-oracle/',
            },
            'oracle-java8-jre' => {
              'package'          => 'oracle-java8-jre',
              'alternative'      => "jre-8-oracle-${oracle_architecture}",
              'alternative_path' => "/usr/lib/jvm/jre-8-oracle-${oracle_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/jre-8-oracle-${oracle_architecture}/",
            },
            'oracle-java8-jdk' => {
              'package'          => 'oracle-java8-jdk',
              'alternative'      => "jdk-8-oracle-${oracle_architecture}",
              'alternative_path' => "/usr/lib/jvm/jdk-8-oracle-${oracle_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/jdk-8-oracle-${oracle_architecture}/",
            },
          }
        }
        'precise', 'trusty': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jdk6' => {
              'package'          => 'openjdk-6-jdk',
              'alternative'      => "java-1.6.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.6.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.6.0-openjdk-${::architecture}/",
            },
            'jre6' => {
              'package'          => 'openjdk-6-jre-headless',
              'alternative'      => "java-1.6.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.6.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.6.0-openjdk-${::architecture}/",
            },
            'jdk7' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jre7' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jdk8' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
              'ppa'              => {
                'name'   => 'openjdk-r',
                'uri'    => 'ppa:openjdk-r/ppa',
                'origin' => 'LP-PPA-openjdk-r',
              },
            },
            'jre8' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
              'ppa'              => {
                'name'   => 'openjdk-r',
                'uri'    => 'ppa:openjdk-r/ppa',
                'origin' => 'LP-PPA-openjdk-r',
              },
            },
            'oracle-jre' => {
              'package'          => 'oracle-j2re1.7',
              'alternative'      => 'j2re1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.7-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.7-oracle/',
            },
            'oracle-jdk' => {
              'package'          => 'oracle-j2sdk1.7',
              'alternative'      => 'j2sdk1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.7-oracle/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.7-oracle/jre/',
            },
            'oracle-j2re' => {
              'package'          => 'oracle-j2re1.8',
              'alternative'      => 'j2re1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.8-oracle/',
            },
            'oracle-j2sdk' => {
              'package'          => 'oracle-j2sdk1.8',
              'alternative'      => 'j2sdk1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.8-oracle/',
            },
            'oracle-java8-jre' => {
              'package'          => 'oracle-java8-jre',
              'alternative'      => "jre-8-oracle-${oracle_architecture}",
              'alternative_path' => "/usr/lib/jvm/jre-8-oracle-${oracle_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/jre-8-oracle-${oracle_architecture}/",
            },
            'oracle-java8-jdk' => {
              'package'          => 'oracle-java8-jdk',
              'alternative'      => "jdk-8-oracle-${oracle_architecture}",
              'alternative_path' => "/usr/lib/jvm/jdk-8-oracle-${oracle_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/jdk-8-oracle-${oracle_architecture}/",
            },
          }
        }
        'stretch', 'vivid', 'wily', 'xenial': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            },
            'jdk8' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            },
            'jre8' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            }
          }
        }
        default: { fail("unsupported release ${::lsbdistcodename}") }
      }
    }
    'OpenBSD': {
      $java = {
        'jdk' => {
          'package'   => 'jdk',
          'java_home' => '/usr/local/jdk/',
        },
        'jre' => {
          'package'   => 'jre',
          'java_home' => '/usr/local/jdk/',
        },
      }
    }
    'FreeBSD': {
      $java = {
        'jdk' => {
          'package'   => 'openjdk',
          'java_home' => '/usr/local/openjdk7/',
        },
        'jre' => {
          'package'   => 'openjdk-jre',
          'java_home' => '/usr/local/openjdk7/',
        },
      }
    }
    'Solaris': {
      $java = {
        'jdk' => {
          'package'   => 'developer/java/jdk-7',
          'java_home' => '/usr/jdk/instances/jdk1.7.0/',
        },
        'jre' => {
          'package'   => 'runtime/java/jre-7',
          'java_home' => '/usr/jdk/instances/jdk1.7.0/',
        },
      }
    }
    'Suse': {
      case $::operatingsystem {
        'SLES': {
          if (versioncmp($::operatingsystemrelease, '12') >= 0) {
            $jdk_package = 'java-1_7_0-openjdk-devel'
            $jre_package = 'java-1_7_0-openjdk'
            $java_home   = '/usr/lib64/jvm/java-1.7.0-openjdk-1.7.0/'
          } elsif (versioncmp($::operatingsystemrelease, '11.4') >= 0) {
            $jdk_package = 'java-1_7_0-ibm-devel'
            $jre_package = 'java-1_7_0-ibm'
            $java_home   = '/usr/lib64/jvm/java-1.7.0-ibm-1.7.0/'
          } else {
            $jdk_package = 'java-1_6_0-ibm-devel'
            $jre_package = 'java-1_6_0-ibm'
            $java_home   = '/usr/lib64/jvm/java-1.6.0-ibm-1.6.0/'
          }
        }
        'OpenSuSE': {
          $jdk_package = 'java-1_7_0-openjdk-devel'
          $jre_package = 'java-1_7_0-openjdk'
          $java_home   = '/usr/lib64/jvm/java-1.7.0-openjdk-1.7.0/'
        }
        default: {
          $jdk_package = 'java-1_6_0-ibm-devel'
          $jre_package = 'java-1_6_0-ibm'
          $java_home   = '/usr/lib64/jvm/java-1.6.0-ibd-1.6.0/'
        }
      }
      $java = {
        'jdk' => {
          'package'   => $jdk_package,
          'java_home' => $java_home,
        },
        'jre' => {
          'package'   => $jre_package,
          'java_home' => $java_home,
        },
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }
}
