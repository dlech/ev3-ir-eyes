EV3 IR Eyes
===========

This is a silly program that uses the LEGO MINDSTORMS EV3 IR Sensor. It is
just a window with a pair of eyes that track the IR beacon.

The sensor looks for the IR beacon and when it sees it, the eyes open. The
eyes will follow the beacon left and right and close when the beacon is out
of range or turned off.

It requires the [ev3dev driver DKMS] (v2.0) in order to communicate with the
sensor.

Compiling
---------

Install required packages:

    sudo apt-get install valac libgtk-3-dev libcairo2-dev

Then just run `make`.

Running
-------

You must be a member of the `ev3dev` group.

    sudo usermod -aG ev3dev <username>

You must log out and log back in for this to take effect.

Then run:

    ./ev3-ir-eyes

[ev3dev driver DKMS]: https://github.com/ev3dev/lego-linux-drivers-dkms