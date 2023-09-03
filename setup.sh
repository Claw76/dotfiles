#!/bin/bash

main() {
    update_and_grade
    purge_unneeded
    install_essentials
    # install_via_nala
    install_flatpaks
    disable_annoying_admin_files
    set_gnome_settings
    install_nix
}

post_setup() { 
    set_shell_nix_zsh
    setup_for_kanata
}

update_and_grade() {
    sudo apt-get update
    sudo apt-get upgrade
}

install_essentials() {
    local packages
    packages=(
        git 
        curl 
        axel 
        nala
    )
    sudo apt-get install "${packages[@]}" -y 
}
 
purge_unneeded() {
    local packages
    packages=(
        firefox
        firefox*
        libreoffice*
        simple-scan
        popsicle*
    )
    sudo apt-get purge "${packages[@]}" -y
}

install_via_nala() {
    local packages
    packages=(
        ubuntu-restricted-extras
        gnome-tweaks
    )
    sudo nala install "${packages[@]}" -y
}

install_flatpaks() {
    local packages
    packages=(
        com.brave.Browser
        com.github.tchx84.Flatseal
    )
    flatpak install "${packages[@]}" -y
}
        # com.discordapp.Discord
        # com.spotify.Client


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
    mkdir -p ~/Projects/dotfiles
    git clone https://github.com/Claw76/dotfiles.git ~/Projects/dotfiles/
    rm -f "$HOME/.config/user-dirs.dirs"
    home-manager switch --flake ~/Projects/dotfiles
    gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMonoNL Nerd Font"
}

for arg in "$@"; do
    case "$arg" in
        setup)
            main || exit 1 
            ;;
    esac
done
