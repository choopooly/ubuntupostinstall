#!/bin/bash
# Mon script de post installation Ubuntu
#
# Nicolargo - 10/2011
# GPL
#
# Syntaxe: # sudo ./ubuntupostinstall.sh
#
# Release notes:
# 1.1: Add tweak for Gnome Shell (thanks to Makino)
# 1.0: First release version
#
VERSION="1.1"

#=============================================================================
# Liste des applications à installer: A adapter a vos besoins
# Voir plus bas les applications necessitant un depot specifique
LISTE=""
# Developpement
LISTE=$LISTE" build-essential vim subversion git git-core rabbitvcs-nautilus anjuta textadept"
# Multimedia
LISTE=$LISTE" vlc x264 ffmpeg2theora oggvideotools istanbul shotwell mplayer hugin nautilus-image-converter pavucontrol gimp gimp-save-for-web ogmrip transmageddon guvcview wavpack mppenc faac flac vorbis-tools faad lame nautilus-script-audio-convert cheese sound-juicer picard arista nautilus-arista milkytracker"
# Network
LISTE=$LISTE" iperf ifstat wireshark tshark arp-scan htop netspeed nmap netpipe-tcp"
# Systeme
LISTE=$LISTE" preload gloobus-preview gparted lm-sensors compizconfig-settings-manager hardinfo fortune-mod libnotify-bin compiz-fusion-plugins-extra"
# Web
LISTE=$LISTE" pidgin pidgin-facebookchat pidgin-plugin-pack flashplugin-installer xchat googleearth-package lsb-core ttf-mscorefonts-installer"
# Gnome Shell (go away Unity...)
LISTE=$LISTE" gnome-shell gnome-tweak-tool gnome-documents gnome-shell-extensions-common gnome-shell-extensions-alternate-tab gnome-shell-extensions-alternative-status-menu gnome-shell-extensions-user-theme gnome-tweak-tool gnome-shell-extensions-workspace-indicator  gnome-shell-extensions-apps-menu gnome-shell-extensions-drive-menu gnome-shell-extensions-system-monitor gnome-shell-extensions-places-menu gnome-shell-extensions-dock gnome-shell-extensions-native-window-placement gnome-shell-extensions-gajim gnome-shell-extensions-xrandr-indicator gnome-shell-extensions-windows-navigator gnome-shell-extensions-auto-move-windows"

#=============================================================================

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "Le script doit être lancé en root: # sudo $0" 1>&2
  exit 1
fi

# Ajout des depots
#-----------------

UBUNTUVERSION=`lsb_release -cs`
echo "Ajout des depots pour Ubuntu $UBUNTUVERSION"

# Mon depot a moi
#add-apt-repository ppa:nicolashennion/ppa
#LISTE=$LISTE" sjitter"

# Restricted extra
# The Ubuntu Restricted Extras will install Adobe Flash Player, Java Runtime Environment (JRE) (sun-java-jre) with Firefox plug-ins (icedtea), a set of Microsoft Fonts (msttcorefonts), multimedia codecs (w32codecs or w64codecs), mp3-compatible encoding (lame), FFMpeg, extra Gstreamer codecs, the package for DVD decoding (libdvdread4, but see below for info on libdvdcss2), the unrar archiver, odbc, and cabextract. It also installs multiple "stripped" codecs and avutils (libavcodec-unstripped-52 and libavutil-unstripped-49).
LISTE=$LISTE" ubuntu-restricted-extras"

# Dropbox + pre-requirement Dropbox scripts
# Depot is added during the .deb installation
#add-apt-repository "deb http://www.getdropbox.com/static/ubuntu $UBUNTUVERSION main"
#apt-key adv --keyserver pgp.mit.edu --recv-keys FC918B335044912E
#LISTE=$LISTE" nautilus-dropbox xclip zenity"

# PPAsearch
#add-apt-repository ppa:wrinkliez/ppasearch
#LISTE=$LISTE" ppasearch"

# GStreamer, daily build
add-apt-repository ppa:gstreamer-developers

# Shutter, outil de capture d'ecran
add-apt-repository ppa:shutter
LISTE=$LISTE" shutter"

# Chromium, LE navigateur Web (dev-channel PPA)
add-apt-repository ppa:chromium-daily/dev
LISTE=$LISTE" chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra chromium-codecs-ffmpeg-nonfree"

# Wine
add-apt-repository ppa:ubuntu-wine
LISTE=$LISTE" wine"

# Ubuntu tweak
add-apt-repository ppa:tualatrix/ppa
LISTE=$LISTE" ubuntu-tweak"

# Hotot
add-apt-repository ppa:hotot-team
LISTE=$LISTE" hotot"

# Terminator
add-apt-repository ppa:gnome-terminator/ppa
LISTE=$LISTE" terminator"

# GetDeb
grep '^deb\ .*getdeb' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
	echo -e "\n## GetDeb\ndeb http://archive.getdeb.net/ubuntu oneiric-getdeb apps\n" >> /etc/apt/sources.list
	wget -q -O- http://archive.getdeb.net/getdeb-archive.key | apt-key add -
fi

# Spotify
egrep '^deb\ .*spotify' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
	echo "## 'Spotify' repository"
	echo -e "deb http://repository.spotify.com stable non-free\n" >> /etc/apt/sources.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4E9CFF4E
fi
LISTE=$LISTE" spotify-client-qt"

# WebUpd8 (lots of fresh software)
add-apt-repository ppa:nilarimogard/webupd8
LISTE=$LISTE" dropbox-share"

# Gedit Gmate
apt-add-repository ppa:ubuntu-on-rails/ppa
LISTE=$LISTE" gedit-gmate"

# VirtualBox 4.1
egrep '^deb\ .*virtualbox' /etc/apt/sources.list > /dev/null
if [ $? -ne 0 ]
then
	echo "## 'VirtualBox' repository"
	echo "deb http://download.virtualbox.org/virtualbox/debian oneiric contrib" >> /etc/apt/sources.list
	wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -
fi
LISTE=$LISTE" virtualbox-4.1 dkms"

# LibreOffice
add-apt-repository ppa:libreoffice/ppa
LISTE=$LISTE" libreoffice libreoffice-gnome"

# WebUpd8 Gnome3 plugins
add-apt-repository ppa:webupd8team/gnome3

# Jupiter (only for Laptop)
add-apt-repository ppa:webupd8team/jupiter
LISTE=$LISTE" jupiter"

# Mise a jour 
#------------

echo "Mise a jour de la liste des depots"
apt-get update

echo "Mise a jour du systeme"
apt-get upgrade

# Installations additionnelles
#-----------------------------

echo "Installation des logiciels suivants: $LISTE"

apt-get install $LISTE

# Gnome-shell
#############

THEME_SHELL=Faience
THEME_ICONES=Faience-Dark

# Tweak Gnome shell to display icons in the top bar
git clone https://github.com/rcmorano/gnome-shell-gnome2-notifications.git
cp -r gnome-shell-gnome2-notifications/gnome-shell-gnome2-notifications@emergya.com /usr/share/gnome-shell/extensions/
rm -rf gnome-shell-gnome2-notifications

# Install icons
apt-get install faenza-icon-theme faenza-icons-mono
wget http://www.deviantart.com/download/255099649/faience_icon_theme_by_tiheum-d47vo5d.zip
mkdir $HOME/.themes
unzip faience_icon_theme_by_tiheum-d47vo5d.zip
mv Faience* $HOME/.icons/
rm -rf faience_icon_theme_by_tiheum-*.zip
chown -R $USERNAME:$USERNAME $HOME/.icons

# Install Gnome Shell themes
wget http://www.deviantart.com/download/255097456/gnome_shell___faience_by_tiheum-d47vmgg.zip
unzip gnome_shell___faience_by_tiheum-d47vmgg.zip
mkdir $HOME/.themes
mv Faience $HOME/.themes
rm -rf gnome_shell___faience_by_tiheum-*.zip
chown -R $USERNAME:$USERNAME $HOME/.themes

# Set the theme shell and icons 
gsettings set org.gnome.shell.extensions.user-theme name $THEME_SHELL
gsettings set org.gnome.desktop.interface icon-theme $THEME_ICONES

# Get the minimize and maximize button back in Gnome Shell
gconftool-2 -s -t string /desktop/gnome/shell/windows/button_layout ":minimize,maximize,close"

# ALT-F2 get back to me 
gconftool-2 --recursive-unset /apps/metacity/global_keybindings

# Gnome-shell is the default shell
sed -i ‘s/user-session.*/user-session=Gnome/’ /etc/lightdm/lightdm.conf

# Others
########

# GoogleEarth (besoin de generer package)
make-googleearth-package --force
sudo dpkg -i GoogleEarth*.deb
rm -f GoogleEarth*.deb GoogleEarthLinux.bin

# DVD
sudo sh /usr/share/doc/libdvdread4/install-css.sh

# Fortune
cd /usr/share/games/fortunes/
wget http://www.fortunes-fr.org/data/litterature_francaise
strfile litterature_francaise litterature_francaise.dat
wget http://www.fortunes-fr.org/data/personnalites
strfile personnalites personnalites.dat
wget http://www.fortunes-fr.org/data/proverbes
strfile proverbes proverbes.dat
wget http://www.fortunes-fr.org/data/philosophie
strfile philosophie philosophie.dat
wget http://www.fortunes-fr.org/data/sciences
strfile sciences sciences.dat
cd -

# Custom .bashrc
cat >> $HOME/.bashrc << EOF
alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'
export MOZ_DISABLE_PANGO=1
EOF
source $HOME/.bashrc

# Sensors detect
sensors-detect

# Restart Nautilus
nautilus -q

echo "========================================================================"
echo
echo "Liste des logiciels installés: $LISTE"
echo
echo "========================================================================"
echo
echo "Le script doit relancer votre session pour finaliser l'installation."
echo "Assurez-vous d’avoir fermé tous vos travaux en cours avant de continuer."
echo "Appuyer sur la touche ENTER pour relancer votre session"
read ANSWER
service lightdm restart

# Fin du script
#---------------
