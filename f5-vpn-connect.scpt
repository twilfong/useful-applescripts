#!/usr/bin/env osascript
#
# Automate F5 BigIP Client by filling in username, password, and TOTP code.
#
# Usage: f5-vpn-connect <username> [<totp_code>]
#
# Replace keyring command as needed.
#
# If using keyring command installed by python keyring module, then create
# the keyring entry with this command: `keyring set bigip_pass my_username`
#
# Note script has been updated due to UI changes in BigIP client

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

	# If username doesn't have a domain use @cable.comcast.com
	set AppleScript's text item delimiters to "@"
	try
		set domain to text item 2 of username
	on error
		set username to username & "@cable.comcast.com"
	end try
	
	# Note for debuging future UI changes, insert following 2 lines at appropriate stages
	# set uiElems to entire contents
	# return uiElems

	# Open the app and fill out fields
	tell application "BIG-IP Edge Client"
		activate
		tell application "System Events"
			tell process "BIG-IP Edge Client"
				tell window "BIG-IP Edge Client"
					click radio button "Connect" of radio group 1
					# Wait until the connect dialog is loaded
					repeat until exists UI element "Sign in" of group 2 of UI element 1 of scroll area 1 of group 1
						delay 0.1
					end repeat
					# Now fill in the vpn client dialog
					tell UI element 1 of scroll area 1 of group 1
						# Enter username@domain
						set value of text field 1 of group 2 to username
						click button "Next" of group 4 of group 2
						# Wait for password dialog
						repeat until exists UI element "Enter password" of group 2
							delay 0.1
						end repeat
						# Enter password
						set value of text field 1 of group 2 to mypass
						click button "Sign in" of group 4 of group 2
						# If we have a value for the OTP code then fill that in
						if otp is not {} then
							# Wait until the OTP code dialog is loaded
							repeat until exists UI element "Enter code" of group 2
								delay 0.1
							end repeat
							set value of text field 1 of group 2 to otp
							click button "Verify" of group 7 of group 2
						end if
					end tell
				end tell
			end tell
		end tell
	end tell
	return
end run
