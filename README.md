  * Rafael Ramírez Salas
  * Ingeniería de Computadores, Universidad de Málaga
  * Trabajo de Fin de Grado 2024: Fail Tolerant DualNano

## Fail Tolerant DualNano - FT_DualNano

This project is developed by Rafael Ramírez Salas as part of his final year project at the University of Málaga, Computer Engineering department. The project is titled "Fail Tolerant DualNano".

## Overview

This Python code provides functionality to a graphical interface that reads data, through the serial terminal, from two Arduino controllers, analyzes them, and translates them visually for easier and simpler system monitoring. It handles serial communication with devices connected through specific USB ports.

## Configuration

The script is configured through the following variables:

- `PORTS`: A list of the serial ports that the script will connect to. By default, it is set to '/dev/ttyUSB0' and '/dev/ttyUSB2'.

- `BAUDRATE`: The baud rate for the serial communication. By default, it is set to 9600.

Additionally, several colors are defined for the user interface, which can be customized as needed.

## Functions

The script contains the function initialize_serial(self), which attempts to start serial communication with each of the ports specified in PORTS. If it cannot open a port, it prints an error message.

## Dependencies

The script depends on the serial module for serial communication and the FT_DualNano_support module for additional support functions.

## Usage

To use this script, simply run the FT_DualNano.py file in your Python environment. Make sure you have all dependencies installed and have correctly set up the ports and baud rate.

## Contributing

Contributions are welcome. Please open an issue to discuss your ideas before making a change.

## License

This project is licensed under the terms of the MIT license.