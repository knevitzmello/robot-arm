# robot-arm
A graphical interface developed in Processing that implements a reverse kinematics algorithm to control a 3-joint robotic arm.

At startup, the program automatically searches for an Arduino-connected COM port. The corresponding Arduino code is available in this repository.

## Features:
- Real-time visualization: The GUI displays a projection of the robot arm at the center of the screen.
- Mouse control: Pressing the 'M' key allows the end effector (the last joint) to follow the mouse cursor. The program then calculates the inverse kinematics and sends the required joint angles to the Arduino, enabling the motors to reach the desired position.
- Keyboard control: The WASD keys adjust the end effector’s position along the X/Z axes.
- Base rotation: Pressing the 'G' key rotates the arm’s base towards the mouse pointer, allowing intuitive angle control.
- Gripper control: The 'O' and 'C' keys open and close the end effector, with the program calculating the correct angles automatically.
- USB Communication: All calculated angles are transmitted via USB to the Arduino, ensuring precise movement execution.

This interface was originally designed to work with the Arduino software in this repository but can be adapted for other applications.
