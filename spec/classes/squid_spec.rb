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

  context 'custom refresh_pattern' do
    let(:params) {
      {
        :refresh_pattern => 'refresh_pattern .deb$ 0 20% 360 override-expire'
      }
    }

    it {
      should contain_file('/etc/squid3/squid.conf').with_content(/^refresh_pattern \.deb\$ 0 20/)
    }
  end

  context 'ensure the absence of negative_ttl value by default' do
    it {
      should contain_file('/etc/squid3/squid.conf').without_content(/^negative_ttl/)
    }
  end

  context 'custom negative_ttl value' do
    let(:params) {
      {
        :negative_ttl => '1440'
      }
    }

    it {
      should contain_file('/etc/squid3/squid.conf').with_content(/^negative_ttl 1440 seconds$/)
    }
  end
end

