Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/xenial64"

    config.vm.network "private_network", ip: "192.168.100.100"

    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--cpus", "1"]

        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end

    config.vm.synced_folder "../", "/var/www/", id: "v-root", mount_options: ["rw", "tcp", "nolock", "noacl", "async"], type: "nfs", nfs_udp: false

    config.vm.provision "shell", path: "dist/scripts/vagrant.sh"

    config.vm.hostname = "foodlery"
    config.hostsupdater.aliases = [
        "my.site.com",
        "phpmyadmin.dev"
    ]
end
