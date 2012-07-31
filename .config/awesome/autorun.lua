--run_once("xscreensaver", "-no-splash")         -- starts screensaver daemon 
--run_once("redshift", "-o -l 0:0 -b 0.5 -t 6500:6500") -- brightness
--run_once("ibus-daemon", "--xim") -- ibus
--run_once(os.getenv("HOME") .. "/.dropbox-dist/dropboxd") -- dropbox
--run_once("nm-applet") -- networking
--run_once("wmname", "LG3D") -- java fix
--run_once("sh " .. os.getenv("HOME") .. "/.screenlayout/dual-monitor.sh") -- set screens up

run_once("xsetroot", "-cursor_name top_left_arrow")
run_once("xset", "s off")
run_once("xset", "dpms 300 600 600")
run_once("xrdb", "-load " .. os.getenv("HOME") .. "/.Xdefaults")
