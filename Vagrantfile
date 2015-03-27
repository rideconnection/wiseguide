Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  
  config.vm.define "db", primary: true do |db|
    db.vm.network :private_network, type: "dhcp"
  
    db.vm.provider :virtualbox do |vb|
      vb.name = "wiseguide-development-trusty"
      vb.customize ["modifyvm", :id, "--memory", "512"]
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
