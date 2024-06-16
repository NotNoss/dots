#!/bin/sh

# Check if script was run as root
if [ $USER != "root" ]; then
  echo "Please run this script as root"
  exit 1
fi

# Set directory variables
i3default="/home/$SUDO_USER/.config/i3"
dmconfigdir="/usr/share/sddm/themes/"

# Questions about install
read -p "Would you like the config for desktop (y/N): " desktop
read -p "Would you like to install steam (y/N): " steam
read -p "Would you like to install go-xlr utilities (y/N): " goxlr
#read -p "Would you like to install vmware-workstation (y/N): " vmware

# Install packages from arch repo
pacman --noconfirm -S neovim nodejs npm pnpm zsh stow zoxide xautolock sddm kitty polybar rofi tmux spotify-launcher obsidian go gopls bash-language-server vim thunar playerctl pass lua flatpak discord gnome-disk-utility feh

# Check if default i3 directory exists, if so, remove it
if [ -d $i3default ]; then
  rm -rf $i3default
fi

# Handle operations based on answers to questions asked earlier
case $desktop in
"y" | "Y" | "yes" | "YES")
  sudo -u $SUDO_USER git clone https://github.com/NotNoss/dots.git /home/$SUDO_USER/dots
  sudo -u $SUDO_USER stow /home/$SUDO_USER/dots
  ;;

*)
  sudo -u $SUDO_USER git clone https://github.com/NotNoss/dots.git /home/$SUDO_USER/dots
  cd /home/$SUDO_USER/dots
  sudo -u $SUDO_USER git checkout -b laptop origin/laptop
  sudo -u $SUDO_USER stow .
  cd
  ;;
esac

case $steam in
"y" | "Y" | "yes" | "YES")
  pacman --noconfirm -S steam
  ;;
esac

case $goxlr in
"y" | "Y" | "yes" | "YES")
  sudo -u $SUDO_USER yay --noconfirm -S go-xlr-utility go-xlr-utility-gui
  ;;
esac

# case $vmware in
#   "y" | "Y" | "yes" | "YES")
#     sudo -u $SUDO_USER yay --noconfirm -S vmware-workstation
#     ;;
# esac

# Install from aur
sudo -u $SUDO_USER yay --noconfirm -S spicetify-cli sddm-theme-tokyonight-git picom-ft-udev betterlockscreen brave-bin i3lock-color oh-my-posh

# Install TPM for tmux
sudo -u $SUDO_USER git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Check if sddm theme dir exists, if not, create it
if [ ! -d $dmconfigdir ]; then
  mkdir -p $dmconfigdir
fi

# Clone repo to dm config dir
git clone https://github.com/NotNoss/sddm-config.git $dmconfigdir/tokyo-night-sddm
mv $dmconfigdir/tokyo-night-sddm/sddm.conf /etc/

# Handle display manager services
systemctl disable lightdm
systemctl enable sddm

# Remove un-needed packages
pacman --noconfirm -Rns lightdm lightdm-slick-greeter xfce4-terminal
