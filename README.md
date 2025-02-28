# .files

## Install

Install Arch Linux using archinstall or manual.

After installation run the following commands in this folder.

```sh
stow .
```

```sh
./archsetup.sh --uni --haskell --kde --nvidia --gaming --aur --wol enp42s0
```

> Available options can be listed using `./archsetup.sh -h`

### KDE

Use the `--kde` flag with `./archsetup.sh`.

#### Load Config

Inside this folder run:

```sh
konsave -i ./kde_profiles/kde_lumi.knsv
```

#### Export Config

> Add `-f` when updating a existing config.

```sh
konsave -s PROFILE_NAME
```

```sh
konsave -e PROFILE_NAME
```

Copy the `.knsv` to the `./kde_profiles` folder.

## Boot Splash screen

### Prepare

Plymouth should have been installed using `./archsetup.sh`

Use gimp to scale your boot picture to the dimensions of your monitor (3440x1440 in my case).

### Install

In `/etc/mkinitcpio.conf` add `plymouth` after `udev`

Copy the cropped image to `/usr/share/plymouth/themes/spinner/background-tile.png`

```sh
plymouth-set-default-theme -R spinner
```

Might have to add `ShowDelay=0` to `[Daemon]` in `/etc/plymouth/plymouthd.conf`

In `/boot/loader/entries/*.conf` add `video=3440x1440` to the `options` in order to change the resolution.

In `/boot/loader/loader.conf` set timeout to `0` to disable the boot menu
