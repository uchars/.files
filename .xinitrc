if [ -z "$SSH_CONNECTION" ]; then
  if [ "$(tty)" = "/dev/tty1" ]; then
    dwm
  fi
fi
