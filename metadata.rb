name 'nginx-passenger'
maintainer 'Sirajudheen Mohamed Ali'
maintainer_email 'sirajudheenam@gmail.com'
license 'MIT'
description 'Installs/Configures nginx-passenger'
long_description 'Installs/Configures nginx-passenger'
version '0.1.1'

supports "debian", ">= 6.0"
supports "ubuntu", ">= 14.04"
supports "centos", ">= 7"
supports "rhel", ">= 7"

depends "apt"
depends "chef-dk"

issues_url 'https://github.com/sirajudheenam/nginx-passenger/issues' if respond_to?(:issues_url)
source_url 'https://github.com/sirajudheenam/nginx-passenger' if respond_to?(:source_url)
