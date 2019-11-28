# f5-vpn-connect

## Prerequisties

* Assumes python keyring module is installed (which comes with `keyring` CLI utility)
  - See: https://pypi.org/project/keyring/
  - Quick install via: `pip install keyring` or `pip3 install keyring`
  - Store password in keyring: `keyring set bigip_pass <my_username>`
* Can edit script to replace keyring command with any command that can read the keychain and output just the password
  - Example:  `security find-generic-password -a my_username -s bigip_pass -w`

## Install

Create a symlink or copy script into a location in your path, then ensure script is executable.

## Usage

`f5-vpn-connect my_username`

If your username on your workstation is the same that the VPN client uses, then you can ommit the username.

If you have second factor auth setup to push to your device, or just want to enter the code into the VPN
client, the above is all you need.

If you would like the automation to paste your auth code into the client for you, and you have a command
line tool to generate the code, then do something like this:

`f5-vpn-connect my_username $(totp my_username)`

If you don't already have a favorite TOTP (or other 2FA) CLI tool, see my python one: https://github.com/twilfong/totp-auth
