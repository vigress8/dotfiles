#!/usr/bin/env bash

depends=(
  "libnotify4"
  "libpangocairo-1.0-0"
  "libpulse0"
  "python3.11"
  "xserver-xorg"
)
makedepends=(
  "pkg-config"
  "libiw-dev"
  "libpulse-dev"
  "libpython3.11-dev"
  "pipx"
)
optdepends=(
  "alsa-utils" # volume widget
  "cmus" # cmus widget
  "jupyter-console" # for interaction with qtile via Jupyter
  "khal" # for khal_calendar widget
  "lm-sensors" # for sensors widget
  "moc" # for moc widget
)
 
# Install Wayland backend if wlroots 0.16 is available
apt-cache show libwlroots-dev | grep -q 'Version: 0.16' && {
  depends+=("libwlroots11")
  makedepends+=("libwlroots-dev")
  optdepends+=("xwayland")
}

INSTALL_OPTDEPENDS="0"

cat << END
Runtime dependencies: ${depends[@]}
Build dependencies: ${makedepends[@]}
Optional dependencies: ${optdepends[@]}
END
read -p "Install optional dependencies (y/N)?" -n 1
case "$REPLY" in 
  y|Y) INSTALL_OPTDEPENDS="1" ;;
  *) ;;
esac

cat << END
This is what shall be installed with apt:
Runtime dependencies: ${depends[@]}
Build dependencies: ${makedepends[@]}
END
[[ INSTALL_OPTDEPENDS="1" ]] && cat << END
Optional dependencies: ${optdepends[@]}
END

echo Installing dependencies...
sudo apt install -y "${depends[@]}" "${makedepends[@]}"
[[ INSTALL_OPTDEPENDS="1" ]] && {
  echo Installing optional dependencies...
  sudo apt install -y "${optdepends[@]}"
}

PIPX_VARS=(
  "PIPX_HOME=/opt"
  "PIPX_BIN_DIR=/usr/bin"
  "PIPX_MAN_DIR=/usr/share/man"
)
echo Installing qtile...
sudo "${PIPX_VARS[@]}" pipx install --python python3.11 --system-site-packages 'qtile[all] @ https://github.com/qtile/qtile.git'
echo Installing qtile-extras...
sudo "${PIPX_VARS[@]}" pipx inject qtile 'qtile-extras @ https://github.com/elparaguayo/qtile-extras.git'
sudo install -Dm644 libqtile/resources/default_config.py -t "/usr/share/doc/qtile/"
sudo install -Dm644 "resources/qtile.desktop" -t "/usr/share/xsessions"
sudo install -Dm644 "resources/qtile-wayland.desktop" -t "/usr/share/wayland-sessions"
sudo ln -s "/opt/venvs/qtile/bin/qtile" "/usr/bin/qtile"
