require "spec_helper"
require "serverspec"

kibana_package_name = "opendistroforelasticsearch-kibana"
kibana_service_name = "kibana"
kibana_config_path  = "/etc/kibana/kibana.yml"
kibana_user_name    = "kibana"
kibana_user_group   = "kibana"
default_user = "root"
default_group = "root"
log_directory = "/var/log/kibana"

case os[:family]
when "openbsd"
  kibana_user_name = "_kibana"
  kibana_user_group = "_kibana"
  default_group = "wheel"
  kibana_package_name = "kibana"
when "freebsd"
  default_group = "wheel"
  kibana_user_group = "www"
  kibana_user_name = "www"
  kibana_package_name = "kibana6"
  kibana_config_path = "/usr/local/etc/kibana/kibana.yml"
end
log_file = "#{log_directory}/kibana.log"

describe package(kibana_package_name) do
  it { should be_installed }
end

describe file(kibana_config_path) do
  it { should exist }
  it { should be_owned_by default_user }
  case os[:family]
  when "openbsd"
    it { should be_grouped_into kibana_user_group }
  else
    it { should be_grouped_into default_group }
  end
  it { should be_mode 644 }
  it { should be_file }
  its(:content_as_yaml) { should include("server.port" => 5601) }
  its(:content_as_yaml) { should include("server.host" => "0.0.0.0") }
  case os[:family]
  when "ubuntu"
    its(:content_as_yaml) { should include("elasticsearch.hosts" => ["http://localhost:9200"]) }
  when "freebsd"
    its(:content_as_yaml) { should include("elasticsearch.url" => "http://localhost:9200") }
  end
  its(:content_as_yaml) { should include("kibana.index" => ".kibana") }
  its(:content_as_yaml) { should include("logging.dest" => log_file) }
end

describe file(log_directory) do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by kibana_user_name }
  it { should be_grouped_into kibana_user_group }
  case os[:family]
  when "openbsd"
    it { should be_mode 770 }
  else
    it { should be_mode 755 }
  end
end

describe file(log_file) do
  it { should exist }
  it { should be_file }
  it { should be_owned_by kibana_user_name }
  it { should be_grouped_into kibana_user_group }
  it { should be_mode os[:family] == "freebsd" ? 640 : 644 }
end

case os[:family]
when "redhat"
  describe file("/etc/sysconfig/kibana") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/^user="#{kibana_user_name}"$/) }
    its(:content) { should match(/^group="#{kibana_user_group}"$/) }
    its(:content) { should match(%r{^chroot="/"$}) }
    its(:content) { should match(%r{^chdir="/"$}) }
    its(:content) { should match(/^nice=""$/) }
    its(:content) { should match(/KILL_ON_STOP_TIMEOUT=1/) }
  end
when "ubuntu"
  describe file("/etc/default/kibana") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/Managed by ansible/) }
    its(:content) { should match(/KILL_ON_STOP_TIMEOUT=1/) }
  end
when "freebsd"
  describe file("/etc/rc.conf.d/kibana") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/^kibana_user="#{kibana_user_name}"$/) }
    its(:content) { should match(/^kibana_group="#{kibana_user_group}"$/) }
    its(:content) { should match(/^kibana_log="#{Regexp.escape(log_file)}"$/) }
    its(:content) { should match(/^kibana_config="#{Regexp.escape(kibana_config_path)}"$/) }
  end
end

describe service(kibana_service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(5601) do
  it { should be_listening }
end
