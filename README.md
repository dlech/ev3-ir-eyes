EV3 IR Eyes
===========

This is a silly program that uses the LEGO MINDSTORMS EV3 IR Sensor. It is
just a window with a pair of eyes that track the IR beacon.

The sensor looks for the IR beacon and when it sees it, the eyes open. The
eyes will follow the beacon left and right and close when the beacon is out
of range or turned off.

It requires the [EV3 UART Sensor Modules] in order to communicate with the
sensor.

[![ScreenShot](http://img.youtube.com/vi/ffRR2iqlgv8/0.jpg)](http://youtu.be/ffRR2iqlgv8)

Compiling
---------

Required packages:
valac libgtk-3-dev libcairo2-dev


[EV3 UART Sensor Modules]: https://github.com/ev3dev/legoev3-uart-sensor-modules
