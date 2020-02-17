# Targets contains all your project
# playbook can be an empty array
targets = {
    "pentest" => {
        "box"           => "kalilinux/rolling-light",
        "version"       => "2019.4.0",
        "ip"            => "",
        "playbooks"     => [
            "res/ansible/main.yml"
        ]
    }
}


Vagrant.configure("2") do |config|
    # Loop trough each target
    targets.each do |name, target|
        box = target["box"]

        config.vm.define name do |build|
            build.vm.box = box
            build.vm.provider :virtualbox do |vb, override|
                vb.name = name
            end
            # Test if version is provided
            if target.key?(:version) and not target["version"]
                build.vm.box_version = target["version"]
            end
            # Test if ip is provided
            if target.key?(:ip) and not target["ip"]
                build.vm.network "private_network", ip: target["ip"]
            end
            
            # Runs the playbooks for a given target 
            # Vagrant generates host file under .vagrant/provisioners/ansible/
            # Further information available at :
            # https://www.vagrantup.com/docs/provisioning/ansible_intro.html
            # To avoid running playbook each time execute the following
            # export ANSIBLE_HOST_KEY_CHECKING=False
            # ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory res/ansible/pb-dummy.yml
            target["playbooks"].each do |playbook|
                build.vm.provision :ansible do |ansible|
                    ansible.playbook = playbook
                end
            end
        end
    end
end