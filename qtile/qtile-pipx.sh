#!/usr/bin/env bash
set -euo pipefail

WAYLAND_BACKEND=NO
INSTALL_OPTDEPENDS=NO
INSTALL_EXTRAS=NO

depends=(
  libnotify4
  libpangocairo-1.0-0
  libpulse0
  python3.11
  xserver-xorg
)
makedepends=(
  libiw-dev
  libpulse-dev
  libpython3.11-dev
  pipx
  pkg-config
)
optdepends=(
  alsa-utils # volume widget
  cmus # cmus widget
  jupyter-console # for interaction with qtile via Jupyter
  khal # for khal_calendar widget
  lm-sensors # for sensors widget
  moc # for moc widget
)

read -p "Install Wayland backend? (y/N)" -r
case "$REPLY" in
  y* | Y*)
    if apt-cache show libwlroots11 | grep -q 'Version: 0.16'; then
      WAYLAND_BACKEND=YES
      depends+=(libwlroots11)
      makedepends+=(libwlroots-dev)
      optdepends+=(xwayland)
    else
      echo "Sorry, looks like wlroots 0.16 is not available in your system's repositories."
    fi
    ;;
  *) ;;
esac

echo "
Runtime dependencies: ${depends[*]}
Build dependencies: ${makedepends[*]}
Optional dependencies: ${optdepends[*]}
"
read -p "Install optional dependencies? (y/N)" -r
case "$REPLY" in
  y* | Y*) INSTALL_OPTDEPENDS=YES ;;
  *) ;;
esac

read -p "Install qtile-extras? (y/N)" -r
case "$REPLY" in
  y* | Y*) INSTALL_EXTRAS=YES ;;
  *) ;;
esac

echo "
This is what shall be installed with apt:
Runtime dependencies: ${depends[*]}
Build dependencies: ${makedepends[*]}"
[[ $INSTALL_OPTDEPENDS = YES ]] && \
echo "Optional dependencies: ${optdepends[*]}"
echo "
Your chosen options:
Install Wayland backend: $WAYLAND_BACKEND
Install optional dependencies: $INSTALL_OPTDEPENDS
Install qtile-extras: $INSTALL_EXTRAS
"

read -p "Proceed? (y/N)" -r
case "$REPLY" in
  y* | Y*) ;;
  *) exit 1 ;;
esac

echo Starting installation...
mkdir -p /tmp/qtile-install
pushd /tmp/qtile-install > /dev/null

echo Installing dependencies...
sudo apt install -y "${depends[@]}" "${makedepends[@]}"
[[ $INSTALL_OPTDEPENDS == YES ]] && {
  echo Installing optional dependencies...
  sudo apt install -y "${optdepends[@]}"
}

export PIPX_HOME=/opt
export PIPX_BIN_DIR=/usr/bin
export PIPX_MAN_DIR=/usr/share/man

echo Installing qtile...
sudo -E pipx install --python python3.11 --system-site-packages 'qtile[all] @ https://github.com/qtile/qtile.git'

[[ $INSTALL_EXTRAS == YES ]] && {
  echo Installing qtile-extras...
  sudo -E pipx inject qtile 'qtile-extras @ https://github.com/elparaguayo/qtile-extras.git'
}

echo Installing desktop files...
sudo install -Dvm644 /dev/stdin /usr/share/doc/qtile/default_config.py \
  <(curl -fsS "https://raw.githubusercontent.com/qtile/qtile/master/libqtile/resources/default_config.py")
sudo install -Dvm644 /dev/stdin /usr/share/xsessions/qtile.desktop \
<(curl -fsS "https://raw.githubusercontent.com/qtile/qtile/master/resources/qtile.desktop")

[[ $WAYLAND_BACKEND == YES ]] && \
  sudo install -Dvm644 /usr/share/wayland-sessions/qtile-wayland.desktop  \
    <(curl -fsS "https://raw.githubusercontent.com/qtile/qtile/master/resources/qtile-wayland.desktop")

sudo ln -s /opt/venvs/qtile/bin/qtile /usr/bin/qtile
echo Success.
popd > /dev/null
