[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

# signal-twin-account

This is a fork of phx's [signal-multi-account](https://github.com/phx/signal-multi-account) and aims to extend the functionality to also work with Flatpak installations of Signal-Desktop.

The Shellscript is targeted at Linux and MacOS to utilize a second Signal account on the same computer.

Run `switch_account.sh` to set up the alternate account, and after that, you should be able to just run the command `sigswap` to toggle between the two accounts.

The Signal application is basically just a UI for what is happening underneath the hood on the filesystem.

If someone wants to create a Powershell or Batch script to do the same for Windows, feel free to so and submit a PR, preferrably to phx. I am just not really interested in that and have no time to support that platform.

## Compatibility

So far, this fork has only been tested on recent Fedora Versions (35 and 36) and therefore, compatibility with MacOS might be broken altough I tried to leave the original code handling those cases intact.

## Installation:

```
git clone https://github.com/redongh/signal-twin-account
cd signal-twin-account
./switch_account.sh
```

## Usage:

To shut down any currently running instance of Signal-Desktop and switch to the other profile and launch Signal-Desktop again use  
`sigswap`

## Updating:

```
cd signal-twin-account
git pull
./switch_account.sh
```

