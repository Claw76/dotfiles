#!/bin/bash

# TODO: Use a setup.log file to log which steps have been done already
#       Also use this to skip steps already done

main() {
    sudo apt-get update
    sudo apt-get upgrade -y

    sudo apt-get install apt-transport-https git curl wget gpg axel nala -y
    sudo apt-get purge firefox libreoffice* -y
    
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt-get update
    sudo nala update
    sudo nala install gnome-tweaks ubunu-restricted-extras -y
    sudo nala install brave-browser code  -y

    flatpak install com.github.tchx84.Flatseal -y

    disable_annoying_admin_files
    set_gnome_settings
    setup_for_kanata

    # TODO: Install Nix
    # TODO: Install home-manager
    # TODO: Recommend reboot
    # TODO: set_shell_nix_zsh

}

install_essentials() {
    local packages
    packages=(
        apt-transport-https
        git 
        curl 
        axel 
        nala
    )
    sudo apt-get install "${packages[@]}" -y 
}

# shellcheck disable=2154
disable_annoying_admin_files() {
    local file_path
    local lns
    local lne

    # Modify sudoers.d to disable admin file in home
    sudo touch /etc/sudoers.d/disable_admin_file_in_home
    echo "Defaults !admin_flag" | \
    sudo tee -a /etc/sudoers.d/disable_admin_file_in_home > /dev/null

    # Modify bash.bashrc to disable admin file in home 
    sudo cp /etc/bash.bashrc /etc/bash.bashrc.bak
    file_path="/etc/bash.bashrc"
    lns=$(grep -n ".sudo_as_admin_successful" $file_path | cut -d ":" -f1)
    lne=$((1+$(grep -n "esac$fi" $file_path | cut -d ":" -f1)))
    sudo sed -i "${lns},${lne}s/^/#/" $file_path
}

install_nix() {
    mkdir -p "$USER/.config/nixpkgs"
    touch "$USER/.config/nixpkgs/config.nix"
    echo "{ allowUnfree = true; }" >> "$USER/.config/nixpkgs/config.nix"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
}


set_gnome_settings() {
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
    gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
    gsettings set org.gnome.desktop.calendar show-weekdate true
    gsettings set org.gnome.desktop.calendar show-weekdate true
    gsettings set org.gnome.desktop.datetime automatic-timezone true
    gsettings set org.gnome.system.locale region "de_DE.UTF-8"
    gsettings set org.gnome.desktop.interface clock-format "24h"
    # gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMonoNL Nerd Font"
}

set_shell_nix_zsh() {
    echo "/home/$USER/.nix-profile/bin/zsh" | \
    sudo tee -a /etc/shells > /dev/null
    chsh -s "$(which zsh)"
}

setup_for_kanata() {
    sudo groupadd uinput
    sudo usermod -aG uinput "$USER"
    sudo usermod -aG input "$USER"
    sudo touch /etc/udev/rules.d/kanata.rules
    echo "KERNEL==\"uinput\", GROUP=\"uinput\", MODE=\"0660\", OPTIONS+=\"static_node=uinput\"" | \
    sudo tee -a /etc/udev/rules.d/kanata.rules > /dev/null
    sudo modprobe uinput
}


setup_home_manager() {   
    mkdir -p ~/.local/state/nix/profiles
    nix run home-manager/release-23.05 -- init --switch

    # TODO: Warn that this will overwrite the current user-dir config
    mkdir -p ~/Projects/dotfiles
    git clone git@github.com:Claw76/dotfiles.git ~/Projects/dotfiles/
    rm -f "$HOME/.config/user-dirs.dirs"
    # TODO: Warn that this is impure because of nixGL
    home-manager switch --flake ~/Projects/dotfiles --impure

    gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMonoNL Nerd Font"
    # TODO: Recommend another reboot
}

for arg in "$@"; do
    case "$arg" in
        setup)
            main || exit 1 
            ;;
    esac
done
