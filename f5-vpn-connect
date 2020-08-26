#!/usr/bin/env osascript
#
# Automate F5 BigIP Client by filling in username, password, and TOTP code
#
# Usage: f5-vpn-connect <username> [<totp_code>]
#
# Replace keyring command as needed.
#
# If using keyring command installed by python keyring module, then create
# the keyring entry with this command: `keyring set bigip_pass my_username`

on run argv
  # Set username and optional OTP from command arguments
	set argv to argv & "" & ""
	set username to item 1 of argv
	set otp to item 2 of argv

  # Get password from keyring
	set keyring_cmd to "keyring get bigip_pass " & username
	try
		set mypass to do shell script (keyring_cmd)
	on error
		return "ERROR: Username " & username & " not found in keyring item bigip_pass."
	end try

	tell application "BIG-IP Edge Client"
		activate
		tell application "System Events"
			tell process "BIG-IP Edge Client"
				tell window "BIG-IP Edge Client"
					click radio button "Connect" of radio group 1
					# Wait until the connect dialog is loaded
					repeat until exists group 3 of UI element 1 of scroll area 1 of group 1
						delay 0.2
					end repeat
					# Now fill in the vpn client dialog
					tell UI element 1 of scroll area 1 of group 1
						set value of text field 1 of group 3 to username
						set value of text field 1 of group 4 to mypass
						click UI element "Sign in" of group 5
						# If we have a value for the OTP code then fill that in
						if otp is not {} then
							# Wait until the OTP code dialog is loaded
							repeat until exists text field 1 of group 2
								delay 0.2
							end repeat
							set value of text field 1 of group 2 to otp
							click UI element "Verify" of group 1 of group 6 of group 2
						end if
					end tell
				end tell
			end tell
		end tell
	end tell
	return
end run
