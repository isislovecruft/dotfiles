--run_once("redshift", "-o -l 0:0 -b 0.5 -t 6500:6500") -- brightness
--run_once("ibus-daemon", "--xim") -- ibus
--run_once(os.getenv("HOME") .. "/.dropbox-dist/dropboxd") -- dropbox
--run_once("nm-applet") -- networking
--run_once("wmname", "LG3D") -- java fix
--run_once("sh " .. os.getenv("HOME") .. "/.screenlayout/dual-monitor.sh") -- set screens up

-- Set the cursor
--run_once("xsetroot", "-cursor_name top_left_arrow")

-- Turn the screensaver off
--run_once("xset", "s off")

-- Standby 300 seconds, suspend 600 seconds, turn off screen 600 seconds
run_once("xset", "dpms 300 600 600")

-- Autorepeat keys after 50 milliseconds, 10 keypresses per second
run_once("xset", "r 40 15")

-- Get the color defaults and terminal settings
run_once("xrdb", "-load " .. os.getenv("HOME") .. "/.Xdefaults")

-- Start xscreensaver daemon
run_once("xscreensaver", "-nosplash")

-- Start conky
run_once("conky")

-- Fix the fucking keyboard so that Emacs works
run_once("sh " .. os.getenv("HOME") .. "/scripts/fix_keymap")

-- Goddamn timeservers.
run_once("sh export -f LOCALTZ='America/Los_Angeles'")