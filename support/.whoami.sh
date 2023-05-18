#!/bin/bash
# Version: 0.0.3
# Capture user's username and computer name
# shellcheck source=/opt/easy-linux/.envrc

scripts_dir=/opt/easy-linux

trap "source ${scripts_dir}/support/trap-master.sh" EXIT

if [ -x "$(command -v direnv)" ]; then
   cd "${scripts_dir}"
   direnv allow && sudo direnv allow
fi

source /opt/easy-linux/.envrc

pkg_info_func() {
    sudo dpkg --get-selections > "${scripts_dir}/support/my_installed_apps.list"
}

get_vars_func() {
    computername=$(cat /etc/hostname)
    user=$USER
    username=$USER
    pwnagotchi="Unknown"
    
    if [[ $pwnagotchi != "Gotcha" && $pwnagotchi != "Sniffer" ]]; then
        pwnagotchi="Unknown"
        
        if [[ "$user" == "$cwb_username" && "$computername" == "$cwb_computername" ]]; then
            pwnagotchi="Gotcha"
            sed -i 's/^pwnagotchi=.*/pwnagotchi=Gotcha/' "${scripts_dir}/.envrc"
        elif [[ "$user" == "$ldb_username" && "$computername" == "$ldb_computername" ]]; then
            pwnagotchi="Sniffer"
            sed -i 's/^pwnagotchi=.*/pwnagotchi=Sniffer/' "${scripts_dir}/.envrc"
        fi
        sed -i 's/^pwnagotchi=.*/pwnagotchi=Unknown/' "${scripts_dir}/.envrc"
    fi
    
    FLAG_FILE="/opt/easy-linux/.envrc_populated"
    
    if [ ! -e "$FLAG_FILE" ]; then
        
        # Function to populate .envrc file
        populate_envrc() {
            #sudo chown 1000:0 /opt/easy-linux/.envrc
            # Add more environment variables as needed
            #    echo "export MY_VAR=my_value" | /opt/easy-linux/.envrc
            echo "export docker_installed=0" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export fatrat_installed=$(if [ -x "$(command -v fatrat)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export hacktool_installed=$(if [ -x "$(command -v hackingtool)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export hcxdump_installed=$(if [ -x "$(command -v hcxdumptool)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export nano_installed=0" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export webmin_installed=$(if [ -x "$(command -v webmin)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export wifite_installed=$(if [ -x "$(command -v wifite)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export stand_install=0" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export airc_installed=$(if [ -x "$(command -v aircrack-ng)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export airc_deps_installed=$(if [ -x "$(command -v aircrack-ng)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export airg_deps_inst=$(if [ -x "$(command -v airgeddon)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export airg_installed=$(if [ -x "$(command -v airgeddon)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export autoj_install=$(if [ -x "$(command -v autojump)" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export user=$USER" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export username=$(whoami)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export useraccount=$(getent passwd 1000 | cut -d ":" -f 1)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export computername=$(cat /etc/hostname)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export hostname=$(cat /etc/hostname)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export computername=$(cat /etc/hostname)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export arch=$(uname -m)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export wordlist=/usr/share/wordlists/Top304Thousand-probable-v2.txt" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export amiPwn=$(if [ -f "/etc/pwnagotchi/config.toml" ]; then echo "1"; else echo "0"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export pwnagotchi=$(if [ "$user" -eq "$cwb_username" -a "$computername" -eq "$cwb_updates" ]; then echo "Gotcha"; else echo "Unknown"; fi)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export pwn_installed=0" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export OS=$(uname -s)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export KERN=$(uname -r)" | sudo tee -a "${scripts_dir}/.envrc"
            echo "export tot_pkgs=$(cat "${scripts_dir}/support/misc/my_installed_apps.list" | grep "install" -c)" | sudo tee -a "${scripts_dir}/.envrc"
        }
        
        # Populate the envrc table
        populate_envrc
        clear
        # Update flag to indicate the function has run.
        touch "$FLAG_FILE"
    fi
}

main() {
    get_vars_func
    pkg_info_func
}

if [ -x "$(command -v direnv)" ]; then
   cd /opt/easy-linux
   direnv allow
   sudo direnv allow

   cd /opt/easy-linux/support
   direnv allow
   sudo direnv allow
fi

main
