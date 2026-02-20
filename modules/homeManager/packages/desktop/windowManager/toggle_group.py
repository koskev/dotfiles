#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# https://github.com/hyprwm/Hyprland/issues/2822

import subprocess
import json
import argparse
parser = argparse.ArgumentParser()
import traceback


EXCLUDE_TITLE = "Picture-in-Picture"

def shell_exec(cmd, dry_run = False):
    if dry_run:
        print(cmd)
        return 
    subprocess.call(cmd, shell=True)

if __name__ == "__main__":
    parser.add_argument("--enable-notify")
    parser.add_argument("--dry-run")
    args = vars(parser.parse_args())
    for k in list(args.keys()):
        if args[k] is None:
            args.pop(k)

    enable_notify = args.get('enable_notify', 'false').lower() == 'true'
    dry_run = args.get('dry_run', 'false').lower() == 'true'

    print('Run with mode: ', args)
    try:
        active_window = json.loads(subprocess.check_output("hyprctl -j activewindow", shell=True))
        if len(active_window['grouped']) > 0:
            shell_exec("hyprctl dispatch togglegroup", dry_run)
        else:
            active_window_address = active_window['address']
            active_space_id = active_window['workspace']['id']
            windows = json.loads(subprocess.check_output(["hyprctl" ,"-j", "clients"]))
            window_on_active_space = [w for w in windows if w['workspace']['id'] == active_space_id]
            should_group_windows = [w for w in window_on_active_space if EXCLUDE_TITLE not in w['title']]
            should_group_windows.sort(key=lambda w: (w['at'][0], w['at'][1]))

            if len(should_group_windows) == 1:
                shell_exec("hyprctl dispatch togglegroup", dry_run)
            else:
                first_window = should_group_windows.pop(0)
                window_args = f'dispatch focuswindow address:{first_window['address']}; dispatch togglegroup; '

                for w in should_group_windows:
                    window_args += f'dispatch focuswindow address:{w['address']}; '
                    for d in ['l','r','u','d']:
                        window_args += f'dispatch moveintogroup {d}; '

                batch_args = f'{window_args} dispatch focuswindow address:{active_window_address}'
                cmd = f'hyprctl --batch "{batch_args}"'
                shell_exec(cmd, dry_run)
    except Exception as e:
        if enable_notify:
            # FIXME: Change to your notification
            subprocess.call(
                "notify-send -a toggle-tab.py 'something wrong, please check log' ",
                shell=True,
            )
        print(traceback.format_exc())
