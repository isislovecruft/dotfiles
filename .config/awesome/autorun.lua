--run_once("redshift", "-o -l 0:0 -b 0.5 -t 6500:6500") -- brightness
--run_once("ibus-daemon", "--xim") -- ibus
--run_once("nm-applet") -- networking
--run_once("wmname", "LG3D") -- java fix

-- Set the root window background
run_once("xsetroot", "-solid black")

-- Set the cursor
--run_once("xsetroot", "-cursor_name top_left_arrow")

-- Turn the screensaver off
--run_once("xset", "s off")

-- Disable audible bell and key clicks:
run_once("xset", "b off")
run_once("xset", "c off")

-- Standby 300 seconds, suspend 600 seconds, turn off screen 600 seconds
run_once("xset", "dpms 300 600 600")

-- Autorepeat keys after 30 milliseconds, 15 keypresses per second
run_once("xset", "r rate 250 22")

-- Get the color defaults and terminal settings
run_once("xrdb", "-load " .. os.getenv("HOME") .. "/.Xdefaults")

-- Start xscreensaver daemon
run_once("xscreensaver", "-nosplash")

-- Start autocutsel so that we have a $CLIPBOARD:
run_once("autocutsel", "-fork &")
run_once("autocutsel", "-selection PRIMARY -fork &")

-- Start various programs:
run_once("conky")
run_once("pidgin")
--run_once("firefox")
run_once("urxvt", "-geometry 159x48+0-1")

-- Goddamn timeservers.
run_once("/bin/bash", "export LOCALTZ='America/Los_Angeles'")
