# global keybind

This can be useful when running a wayland compositor, as it allows you to send applications input without focusing them (or an xwayland window).
For example, you can use this to pass a push-to-talk keybind to a voice chat application.

## usage

Determine the event device for the input device you want to use.
This can be done by running `evtest` and looking for the device with the name of the input device you want to use.
Alternatively, you can use `cat /proc/bus/input/devices` and look for the device with the name of the input device you want to use.

You will also need to determine the event code for the key you want to use.
This can be done by running `evtest`, selecting the device, then pressing the key you want to use.
