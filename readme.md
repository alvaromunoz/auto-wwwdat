# What's this?

A place to get DATS and set them in WWW Mode in [clrmamepro](https://mamedev.emulab.it/clrmamepro)

Right now it's gathering DATs from no-intro and redump.

Following instructions from https://mamedev.emulab.it/clrmamepro/docs/wwwprofiler.txt

# What's working?

- Download redump dats
- Download no-intro daily dats
- Create clrmamepro wwwprofile xml file from dats
- Publish on github pages
- Cron job at 8:00 UTC every day

# What's missing?

- Generate 1R1G DATs using [retool](https://github.com/unexpectedpanda/retool/)
- Zip DATs
- Split redump and nointro in two XML files
- Further clean DAT file names (using name from inside XML?)