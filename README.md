# robot-arm
Graphical interface developed in Processing implementing a reverse kinematics algorithm to position a robot arm with 3 joints.
At the start of the program, it will search for the COM port with an Arduino connected to it. The arduino program is available in this repository too.

The GUI shows the projection of the robot arm at the center. By clicking on the 'M' letter, the end effector (the last point) will follow the mouse movement, the program will then calculate the backwards kinematics and send the angles of rotation of the rotary actuators (the motors that move the joints) to perform the desired position.
The movement can also be performed by using the WASD keys, they increment/decrement the position of the end effector in the X/Z axis.

At the left corner of the GUI, there is the top view of the robot arm. By pressing the 'G' key, the motor will turn towards the mouse pointer, allowing the control of the angle of the base of the arm.

By clicking the 'O' and 'C' keys, the GUI exibits the opening and closing of the end effector (the program also calculates the correct angle for this).

All the calculated angles are then sent via USB to the arduino. This was meant to interface with the arduino software present in this repository, but can be repurposed.
