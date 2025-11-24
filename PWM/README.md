## PWM generator idea
- using the joystick won't give binary values, so a PWM signal is needed to reach all values between 0 and 255.
- The speed will be sent by the RPi and will result in the desired PWM.
- Deadzone added so there will always be enough torque.

- ## TODO
- [ ] test(bench)
- [ ] check if app will allow joystick
