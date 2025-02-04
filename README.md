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
