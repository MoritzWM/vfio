import xbmcaddon
import xbmcgui
from subprocess import call

addon       = xbmcaddon.Addon()
addonname   = addon.getAddonInfo('name')

if xbmcgui.Dialog().yesno(addonname, "This will quit kodi and launch windows, are you sure?"):
    call(["sudo", "systemctl", "start", "windows"])
