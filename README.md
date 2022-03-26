# Archiac

Archlinux Installer and Configuration

![they dont know i use arch meme](assets/arch-meme.png)

I've done a fair amount of Archlinux installations and re-installations
to not want to keep doing it everytime I want to setup my system. Figured I'd
put it all together in one place and automate parts of it, while also backing
up some of my configuration files.

This repository contains some automation scripts, dotfiles, configuration
files, and some hacks.


## Setup

1.  Begin with a bootable drive with the latest Archlinux ISO. Once the ISO
    is downloaded from the [downloads](https://archlinux.org/download/) page,
    create a bootable USB drive using an application like
    [Rufus](https://rufus.ie/en/) on Windows, or with `dd` on linux / MacOS: 
    ```
    dd if=/path/to/archlinux/iso of=/path/to/usb/dev status=progress
    ```
1.  Reboot into the live Archlinux environment
1.  Create and mount partitions as needed. The root partition `/` needs to be
    mounted on `/mnt`, while the EFI partition needs to be at `/mnt/boot`.
    If a seperate home partition is needed, mount it at `/mnt/home`. Refer the
    [Archlinux installation guide](https://wiki.archlinux.org/title/Installation_guide)
    as needed.
1.  Execute the [pre-install script](scripts/preinstall.sh) using `curl`, which
    will proceed with the next steps, setup this repository in the mounted
    partition, configure the installation, unmount and finally reboot. In this
    process, the script will prompt for details such as the system name, primary
    user name and passwords that need to be configured.
    ```
    bash -c "$(curl -fsSL https://raw.github.com/hexbioc/archiac/main/scripts/preinstall.sh)"
    ```
1.  On reboot, unplug the USB drive and if everything goes well, `GRUB` should
    be on-screen, followed by display manager greeter prompting for login.
1.  At this point, login with the user created during the installation, which
    will then continue the setup.


## Open Items

Stuff I intend to implement / add / fix, when time permits, in no particular
order:

-   Add GTK theming
-   Theme the notification popup
-   ~~Verify audio hotplug for type-C as well as 3.5mm port~~ **works**
-   ~~Add display configuration before login in lightdm~~ **done**
-   Configure Qtile for multi-display setups

