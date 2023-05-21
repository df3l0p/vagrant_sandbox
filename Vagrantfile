# DO NOT EDIT THIS FILE
# VM settings are available under config/targets.yaml
require 'yaml'

# source: https://stackoverflow.com/questions/16708917/how-do-i-include-variables-in-my-vagrantfile/26394449
current_dir = File.dirname(File.expand_path(__FILE__))
configs     = YAML.load_file("#{current_dir}/config/targets.yaml")
targets     = configs['targets']

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
if OS.linux?
    audio_driver = 'pulse'
elsif OS.mac?
    audio_driver = 'coreaudio'
elsif OS.windows?
    audio_driver = 'dsound'
end

Vagrant.configure("2") do |config|
    # Loop trough each target
    targets.each do |name, target|
        box = target["box"]

        config.vm.define name do |build|
            build.vm.box = box
            
            build.vm.provider :virtualbox do |vb, override|
                vb.name = name

                # Check if CPUs are defined
                if target["cpus"]
                    vb.cpus = target["cpus"]
                end
                # Check if memory is defined
                if target["memory"]
                    vb.memory = target["memory"]
                end
                # Check if vram is defined
                if target["vram"]
                    vb.customize ["modifyvm", :id, "--vram", target["vram"]]
                end
                
                vb.gui = target["gui"]
                # set the right graphics on linux
                if OS.linux?
                    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
                end

                # enables copy/paste with host and vm
                vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

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
            
            # loops through all playbooks and execute it with right supplier.
            target["playbooks"].each do |playbook|
                build.vm.provision playbook["supplier"] do |ansible|
                    ansible.playbook = playbook["path"]
                    # ansible_local does not support vault pass.
                    if playbook["supplier"] != "ansible_local"
                      ansible.ask_vault_pass = playbook["ask_vault_pass"]
                    end
                end
            end
        end
    end
end
