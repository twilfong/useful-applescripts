
# f5-vpn-connect-with-push-2fa

## Prerequisties

- `pip install keyring` or `pip3 install keyring`
- `keyring set bigip_pass dmuth200` - Enter your password when prompted
   - `keyring get bigip_pass dmuth200` - To view your entered password


## Usage

`./f5-vpn-connect-with-push-2fa username`

This will launch the F5 Big-IP VPN app and log you in, but the 2FA 
authentication will be pushed to your device.


