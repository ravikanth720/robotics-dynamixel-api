//============================================================================
// Name        : CPP_AXControl.cpp
// Author      : JCA
// Version     :
// Copyright   : GPL
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
using namespace std;

#include "SerialPort.h"
#include "Dynamixel.h"
#include "Utils.h"

int main() {
	cout << "AX Control starts" << endl; // prints AX Control

	int error=0;
	int idAX12=18;
	int tossCode=0;
	int pos;

	SerialPort serialPort;
	Dynamixel dynamixel;


	if (serialPort.connect("/dev/ttyUSB0")!=0) {
		//keep trying to sendTossModeCommand till pos value is right.


		do{
		   tossCode =  dynamixel.sendTossModeCommand(&serialPort);
			printf("\n tossCode %d",tossCode);
			// getting position
			pos=dynamixel.getPosition(&serialPort, idAX12);
			Utils::sleepMS(500);
		} while(tossCode==-1 || !(pos>250 && pos <1023));


		//setting position.
		if (pos>250 && pos <1023)
			dynamixel.setPosition(&serialPort, idAX12, pos-100);
		else
			printf ("\nPosition <%i> under 250 or over 1023\n", pos);

		//Lets read some values:
		int load = dynamixel.getLoad(&serialPort,idAX12);
		printf("Load : %d\n", load);

		//Read Torque
		int torq = dynamixel.getTorque(&serialPort,idAX12);
		printf("Torque : %d\n", torq);

		//Read Speed
		int speed = dynamixel.getCurrentSpeed(&serialPort,idAX12);
		printf("Speed : %d\n", speed);

		serialPort.disconnect();
	}
	else {
		printf ("\nCan't open serial port");
		error=-1;
	}

	cout << endl << "AX Control ends" << endl; // prints AX Control
	return error;
}
