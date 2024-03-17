# global keybind

This can be useful when running a wayland compositor, as it allows you to send applications input without focusing them (or an xwayland window).
For example, you can use this to pass a push-to-talk keybind to a voice chat application.

## usage

### cli

Determine the event device for the input device you want to use.
This can be done by running `evtest` and looking for the device with the name of the input device you want to use.
Alternatively, you can use `cat /proc/bus/input/devices` and look for the device with the name of the input device you want to use.

You will also need to determine the event code for the key you want to use.
This can be done by running `evtest`, selecting the device, then pressing the key you want to use.
The resulting code's value can be found from [the linux input-event-codes.h](https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h).

Here is an example invocation of the program that will press F12 when the mouse side button is pressed: `global-keybind-cli --device /dev/input/event0 --key-to-press 275 --key-to-send F12`


### home-manager

A home-manager module is provided under the flake output `homeModules.global-keybind`.
This can be used to start a systemd user service that will run the program.
Here is an example configuration that will press F12 when the mouse side button is pressed:

```nix
global-keybind = {
  enable = true;
  device = "/dev/input/event5";
  display = ":1";
  key_to_press = 275;
  key_to_send = "F12";
};
```
