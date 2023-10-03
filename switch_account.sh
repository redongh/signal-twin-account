#!/bin/sh

cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

if uname -a | grep -F -q Darwin >/dev/null 2>&1; then
  MAC=1
else
  MAC=0
fi

flatpak list --columns application 2> /dev/null | grep -F -q org.signal.Signal
if [ $? -eq 0 ]; then
  FLATPAK=1
else
  FLATPAK=0
fi

if [ $MAC -eq 1 ]; then
  SIGNAL_DIR="${HOME}/Library/Application Support/Signal"
elif [ $FLATPAK -eq 1 ]; then
  SIGNAL_DIR="$HOME/.var/app/org.signal.Signal/config/Signal"
  if [ ! -d "$SIGNAL_DIR" ]; then
    echo "ERROR: FAILED to find flatpak folder for Signal at $SIGNAL_DIR, maybe your distro uses a different path? Aborting!" && exit 1
  fi
else
  SIGNAL_DIR="/opt/Signal"
fi

SECONDARY="${SIGNAL_DIR}.secondary"
TMPDIR="${SIGNAL_DIR}.tmp"
FILEPATH="$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")"

stop_signal() {
  echo 'Stopping Signal...'
  if [ $MAC -eq 1 ]; then
    osascript -e 'Tell application "Signal" to quit'
    sleep 5
  else
    pgrep signal-desktop >/dev/null && pkill signal-desktop
    sleep 3
  fi
}

start_signal() {
  echo 'Starting Signal...'
  if [ $MAC -eq 1 ]; then
    open "/Applications/Signal.app"
  elif [ $FLATPAK -eq 1 ]; then
    flatpak run --branch=stable --arch=x86_64 --command=signal-desktop --file-forwarding org.signal.Signal >/dev/null 2>&1 &
  else
    (signal-desktop &) >/dev/null 2>&1
  fi
}

if [ ! $FLATPAK -a ! -d "$SIGNAL_DIR" ]; then
  echo "No Signal Desktop installation was found"
  exit 1
fi

# if first time starting:
if [ ! -d "$SECONDARY" ]; then
  stop_signal
  mv "$SIGNAL_DIR" "$SECONDARY"
  start_signal
  echo "Please associate your other signal account now, then afterwards hit [Enter]."
  read -n 1 -p "" ENTER
  echo "Please enter your sudo-passoword in order to register the command 'sigswap'"
  sudo ln -sf "$FILEPATH" /usr/local/bin/sigswap && echo "Registration successful; whenever you want to swap accounts, simply run the command 'sigswap'." || echo "ERROR: sigswap could not be registered, you won't be able to use 'sigswap'!"
  exit
fi

# normal functionality:
if ! diff -q "$0" /usr/local/bin/sigswap >/dev/null 2>&1; then
  sudo ln -sf "$FILEPATH" /usr/local/bin/sigswap
fi
stop_signal
mv "$SIGNAL_DIR" "$TMPDIR"
mv "$SECONDARY" "$SIGNAL_DIR"
mv "$TMPDIR" "$SECONDARY"
echo "Switched Signal accounts."
start_signal
exit $?

