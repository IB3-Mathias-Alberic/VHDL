## PROTOCOL FRAME FORMAT

- [Start: 1 byte] : start of a frame sent to drivers => certain character
- [Command: 3 bit] : action needed => 1 of 6 movements
- [Direction: 1 bit] : direction to perform command => 2 directions
- [PWM: 1 Byte] : motorspeed => 0 to 255 is PWM standard
- [Time: 5 bit] : time sent by RPi => 0 to 31 seconds

## TODO
- [ ] receive FSM
- [ ] command interpretation
- [ ] command execution
