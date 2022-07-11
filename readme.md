[![Get DATs](https://github.com/alvaromunoz/auto-wwwdat/actions/workflows/get_dats.yml/badge.svg?branch=master)](https://github.com/alvaromunoz/auto-wwwdat/actions/workflows/get_dats.yml)

## What's this?

A place to get DATS and set them in WWW Mode in [clrmamepro](https://mamedev.emulab.it/clrmamepro)

Right now it's gathering DATs from no-intro and redump.

Following instructions from https://mamedev.emulab.it/clrmamepro/docs/wwwprofiler.txt

## What does it do?

- Download [redump](https://redump.org/downloads) and [no-intro](https://datomatic.no-intro.org/) dats daily
- Create [retool](https://github.com/unexpectedpanda/retool/) dats from daily downloads with preconfigured filters
- Create clrmamepro wwwprofile xml index files
- Publish everything on github pages
- Automate execution at 8:00 UTC every day
