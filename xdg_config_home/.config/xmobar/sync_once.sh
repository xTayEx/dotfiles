timeout 5 zenity --info --text="New emails will be synchronized"
timeout 3m  offlineimap
notmuch new
