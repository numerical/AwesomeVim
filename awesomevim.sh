#!/usr/bin/env bash

VIM_BIN="gvim"
# get current desktop tag id and name
read -r curr_tag_id curr_tag_name <<< "$(wmctrl -d | awk '$2 == "*" {print $1, $NF}')"

# iterate through list of gvim servers
# for each gvim server check if it is in current tag
for servername in $($VIM_BIN --serverlist); do
  cpid=$($VIM_BIN --servername "$servername" --remote-expr "getpid()")
  servertag=$(wmctrl -l -p | awk -vcpid="$cpid" '$3 == cpid {print $2}')
  if [[ "$curr_tag_id" -eq "$servertag" ]]; then
    tag_server=$servername
  fi
done

if [[ -z "$tag_server" ]]; then
  tag_server="$curr_tag_name"
  $VIM_BIN --servername "$tag_server" "$@"
else
  $VIM_BIN --servername "$tag_server" --remote-tab "$@"
fi
