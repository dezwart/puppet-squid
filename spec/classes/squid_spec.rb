require 'spec_helper'
require 'Squid'

describe 'squid' do
  packages = [
    Squid::PACKAGE
  ]

  services = [
    Squid::SERVICE
  ]

  files = [
    "/etc/#{Squid::PACKAGE}/#{Squid::CN}.conf"
  ]

  execs = [
    'Init cache dir'
  ]

  adzapper = 'adzapper'

  context 'default' do
    dirs = [
      '/var/spool/squid3'
    ]

    it {
      packages.map { |x| should contain_package(x) }
    }

    it {
      files.map {
        |x| should contain_file(x).with({
          'ensure' => 'file',
        })
      }
    }

    it {
      dirs.map {
        |x| should contain_file(x).with({
          'ensure' => 'directory',
        })
      }
    }

    it {
      services.map { |x| should contain_service(x) }
    }

    it {
      execs.map { |x| should contain_exec(x) }
    }

    it {
      should_not contain_package(adzapper)
    }
  end

  context 'custom_cache_dir' do
    cache_dir = '/my/hovercraft/is/full/of/eels'

    let(:params) {
      {
        :cache_dir => cache_dir
      }
    }

    it {
      should contain_file(cache_dir).with({
        'ensure' => 'directory',
      })
    }
  end

  context 'with_adzapper' do
    let(:params) {
      {
        :adzapper => true
      }
    }

    it {
      should contain_package(adzapper)
    }
  end
end

