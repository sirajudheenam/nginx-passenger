#
# Cookbook Name:: nginx-passenger
# Recipe:: default
# Install Passenger + Nginx

# include_recipe 'chef-dk'

case node['platform']
  when 'ubuntu', 'debian'
      log "#{node['nginx-passenger']['apt']['uri']}"
      apt_update 'update' do
        action :update
      end
      %w(curl apt-transport-https ca-certificates build-essential).each do |pkg|
        package pkg
      end
      apt_repository "passenger" do
        uri "#{node['nginx-passenger']['apt']['uri']}"
        distribution node['lsb']['codename']
        components ["main"]
        keyserver "keyserver.ubuntu.com"
        key "561F9B9CAC40B2F7"
      end
      apt_update 'update' do
        action :update
      end
      %w(nginx-extras passenger).each  do |pkg|
        package pkg
      end
      service 'nginx' do
        supports :status => true, :reload => true, :restart => true
        action [:start]
      end

  when 'redhat', 'centos'
    %w(epel-release curl gcc-c++ make ruby yum-utils pygpgme).each do |pkg|
      package pkg
    end
    %w(fontconfig fontpackages-filesystem gd libX11 libX11-common libXau libXpm libpng libxcb rubygem-rack rubygem-rake).each do |pkg|
      package pkg
    end
    # Clean up any previously installed nginx
    bash 'cleanup_script' do
      code <<-EOH
      [[ -z `rpm -q nginx-filesystem` ]] || rpm -e $(rpm -q nginx-filesystem)
      `yum -q list installed nginx &>/dev/null` && `yum remove -y nginx` || echo "nginx is not previously installed"
      # yum --disablerepo=* --enablerepo=passenger install nginx passenger -y
      EOH
    end
    yum_repository 'passenger' do
      description "Passenger repo"
      baseurl "https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch"
      gpgkey 'https://packagecloud.io/gpg.key'
      gpgcheck false
      repo_gpgcheck true
      sslcacert "/etc/pki/tls/certs/ca-bundle.crt"
      sslverify true
      enabled true
      action :create
    end
    yum_repository 'passenger-source' do
      description "Passenger Source repo"
      baseurl "https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/SRPMS"
      gpgkey 'https://packagecloud.io/gpg.key'
      gpgcheck false
      repo_gpgcheck true
      sslcacert "/etc/pki/tls/certs/ca-bundle.crt"
      sslverify true
      enabled true
      action :create
    end
    %w(nginx passenger).each do |pkg|
      yum_package pkg do
        options '--disablerepo=* --enablerepo=passenger'
      end
    end
    template '/etc/nginx/conf.d/passenger.conf' do
      source 'passenger.conf.erb'
      mode '0644'
      owner 'root'
      group 'root'
    end
    service 'nginx' do
      supports :status => true, :reload => true, :restart => true
      action [:enable,:start]
    end
end
