awesome-config
==============

These are my configuration files for the awesome window manager (awesomewm).
It is written for version > ~4.0 (I only verified against version 4.3).

It basically is customization of a config I found at https://github.com/garyparrot/dotfiles.
The config is still in kind of a rough state, with "only" a custom system tray list and a couple of goodies applied.
This is still in need of love regarding custom key bindings I guess and a proper cleanup. Who knows wether or not I
will touch it ever again .... :D
This config has been tested on Manjaro Linux, but theoretically should work for both FreeBSD and Linux in general.

It is still work in progress but feel free to use it ;)

Installation
------------

* Put all the files into the ~/.config/awesome
* For the CPU, RAM  and brightnes widgets to work, clone the https://github.com/streetturtle/awesome-wm-widgets.git
  repository into your `$XDG_CONFIG_HOME/awesome/widgets/` directory
* For the media control buttons (volume up/down, mute) to work with pulseaudio control, clone
  https://github.com/mokasin/apw.git into your `$XDG_CONFIG_HOME/awesome/widgets/` directory
* you will need the following applications installed for all the widgets & functionalities to work properly:
  * compton
  * nm-applet
  * blueman-applet
  * pasystray
  * xfce4-power-manager
  * xfce4-clipman
  * xscreensaver

