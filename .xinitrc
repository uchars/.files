[ -s "$HOME/.config/desktop.sh" ] && source $HOME/.config/desktop.sh
echo $CUSTOM_DESKTOP
if [ -z "$SSH_CONNECTION" ]; then
  if [ "$(tty)" = "/dev/tty1" ]; then
    if [ ! -z "${CUSTOM_DESKTOP}" ]; then
      echo $CUSTOM_DESKTOP
      $CUSTOM_DESKTOP
    fi
  fi
fi
