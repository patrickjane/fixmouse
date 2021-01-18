![GitHub](https://img.shields.io/github/license/patrickjane/fixmouse?color=blue) ![GitHub release (latest by date)](https://img.shields.io/github/v/release/patrickjane/fixmouse)

# FixMouse

A mouse acceleration killer for macOS (compatible with **macOS catalina**)

## Description

A tiny console program which disables mouse acceleration on macOS. It also **keeps** the mouse acceleration disabled, even if other programs reset the mouse acceleration. This means, it is *running in background*.

## Installation

You can either use the provided installer, or manually run the program whenever you need it. Download the installer from the [list of releases](https://github.com/patrickjane/fixmouse/releases/latest).

Using the installer will copy the binary to `/Applications/FixMouse/fixmouse`. Also, autostart will be enabled by copying the file `de.s710.fixmouse.plist` to `/Library/LaunchAgents/`. This will assure that fixmouse runs upon startup.

### Building from source

If you would like to build from source, first ensure that you have
the Xcode command line tools installed, and then compile the executable with clang:

```sh
$ clang -fmodules main.m -o fixmouse
```

To run the compiled executable at startup, you can manually copy it to
`/Applications/FixMouse`, and then move the plist to the directory mentioned
above.

### Manual usage

The program has 3 modes of operation:

- Get - retrieves the current mouse acceleration, prints it to console then exits
- Set - disables mouse acceleration, then exists
- Loop - keeps running and keeps resetting mouse acceleration

```
$ ./fixmouse
fixmouse - macOS mouse acceleration killer v1.0
(c) 2019 Patrick Jane - https://github.com/patrickjane/fixmouse
Usage:
   $ fixmouse [command]
Commands:
   get       - retrieves the current mouse acceleration and prints it to console
   set       - kills mouse acceleration once
   loop      - kills mouse acceleration repeatedly (program will not terminate)
```

If mouse acceleration is disabled, `get` will print a value of `-65536`. If it is not disabled, some other positive value will be shown.

# Uninstall

To uninstall, simply delete the `/Applications/FixMouse` folder as well as the file `/Library/LaunchAgents/de.s710.fixmouse.plist`.

