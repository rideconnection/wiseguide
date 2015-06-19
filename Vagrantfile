# This is a base 64-bit Ubuntu 14.02 LTS box. Use for testing your recipes.
# Do not use for production deployments. See the README for more info.

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :private_network, type: "dhcp"
  config.vm.define "db", primary: true do |db|
    db.vm.provider :virtualbox do |vb|
      vb.name = "wiseguide-development-trusty"
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    config.trigger.after [:up, :resume, :reload], :stdout => false, :stderr => false do
      get_ip_address = %Q(vagrant ssh #{@machine.name} -c 'ifconfig | grep -oP "inet addr:\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | grep -oP "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | tail -n 2 | head -n 1' 2> /dev/null)
      @logger.debug "Running `#{get_ip_address}`"
      output = `#{get_ip_address}`
      @logger.debug "Output received:\n----\n#{output}\n----"
      puts "==> #{@machine.name}: Available on DHCP IP address #{output.strip}"
      @logger.debug "Finished running :after trigger"
    end
    db.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "locale"
      chef.add_recipe "apt"
      chef.add_recipe "apt-upgrade-once"
      chef.add_recipe "build-essential"
      chef.add_recipe "vim"
      chef.add_recipe "postgresql::server"
      chef.add_recipe "postgresql::contrib"

      chef.json = {
        postgresql: {
          pg_hba: [
            {
              :type => 'local', 
              :db => 'all', 
              :user => 'all', 
              :addr => '', 
              :method => 'trust'
            },
            {
              :type => 'host', 
              :db => 'all', 
              :user => 'all', 
              :addr => '0.0.0.0/0', 
              :method => 'md5'
            },
            {
              :type => 'host', 
              :db => 'all', 
              :user => 'all', 
              :addr => '::/0', 
              :method => 'md5'
            }
          ],
          config: { listen_addresses: '*' },
          config_pgtune: { db_type: 'desktop' },
          contrib: {
            extensions: ["fuzzystrmatch"]
          },
          # https://github.com/opscode-cookbooks/postgresql#chef-solo-note
          # set to md5 of empty string
          password: { postgres: "d41d8cd98f00b204e9800998ecf8427e" }
        },
      }
    end
  end
end
