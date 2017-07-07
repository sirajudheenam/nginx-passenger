default['nginx-passenger']['ubuntu']['codename'] = node['lsb']['codename']
default['nginx-passenger']['apt']['uri'] = "https://oss-binaries.phusionpassenger.com/apt/passenger"
default['nginx-passenger']['passenger_root'] = "/usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini"
default['nginx-passenger']['passenger_ruby'] = "/usr/bin/ruby"
default['nginx-passenger']['passenger_instance_registry_dir'] = "/var/run/passenger-instreg"
