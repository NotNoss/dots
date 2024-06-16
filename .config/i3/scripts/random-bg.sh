#!/bin/sh

wallpapers="~/dots/wallpapers"

while true; do
  feh --randomize --bg-fill $wallpapers/*
  sleep 300
done
