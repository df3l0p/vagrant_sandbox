# Targets contains all your project
# playbook can be an empty array
targets = {
    "pentest" => {
        "box"           => "kalilinux/rolling",
        "version"       => "2020.2.1",
        "ip"            => "",
        "reqAudio"      => true,
        "playbooks"     => [
            "res/ansible/main.yml"
        ]
    }
}

# Module used to identify host OS 
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

# handling specifig hosts variables
audio_driver = ''
ansible_supplier = 'ansible'
if OS.linux?
    audio_driver = 'pulse'
elsif OS.mac?
    audio_driver = 'coreaudio'
elsif OS.windows?
    audio_driver = 'dsound'
    ansible_supplier = 'ansible_local'
end

Vagrant.configure("2") do |config|
    # Loop trough each target
    targets.each do |name, target|
        box = target["box"]

        config.vm.define name do |build|
            build.vm.box = box
            build.vm.provider :virtualbox do |vb, override|
                vb.name = name
                # Setups audio
                if target["reqAudio"]
                    vb.customize [
                        "modifyvm", :id, 
                        "--audio", audio_driver,
                        "--audiocontroller", "ac97",
                        "--audioout", "on"
                    ]
                end
            end
            # Test if version is provided
            if not target["version"].empty?
                build.vm.box_version = target["version"]
            end
            # Test if ip is provided
            if not target["ip"].empty?
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
                build.vm.provision ansible_supplier do |ansible|
                    ansible.playbook = playbook
                end
            end
        end
    end
end
