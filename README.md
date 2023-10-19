# Dynv6UC
DynV6 update cliente running as windows service.

Use Lazarus to compile.
Uses ControlTimer and laz_synapse.
Uses libeay32.dll and ssleay32.dll.
This is a x64 exe and dll versions.

Ini file must contain:
[GENERAL]
token=yourtoken
server=yourhost.dynv6.net
refreshtime=10

Run install.bat to install and uninstall.bat to uninstall.
After install you have to reboot your computer.
This repository will no longer be updated and will remain for posterity. I migrated to CloudFlare which is more reliable.
