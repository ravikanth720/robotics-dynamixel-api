//============================================================================
// Name        : CPP_AXControl.cpp
// Author      : JCA
// Version     :
// Copyright   : GPL
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
using namespace std;
#include <sys/time.h>
#include "SerialPort.h"
#include "Dynamixel.h"
#include "Utils.h"

float timedifference_msec(struct timeval t0, struct timeval t1)
{
	return (t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec - t0.tv_usec) / 1000.0f;
}

int main() {
	cout << "AX Control starts" << endl; // prints AX Control
	struct timeval stop, start;
	struct timeval t0;
	struct timeval t1;
	int error = 0;
	int idAX12 = 18;
	int tossCode = 0;
	int pos;
	int choice;
	int ii = 1, i = 0;
	int load, torq, speed;
	SerialPort serialPort;
	Dynamixel dynamixel;
	int quitOption = 0;
	time_t s, t;
	FILE *f = fopen("positions.txt", "w");

	if (serialPort.connect("/dev/ttyUSB0") != 0) {
		//keep trying to sendTossModeCommand till pos value is right.

		do {
			tossCode =  dynamixel.sendTossModeCommand(&serialPort);
			printf("\n tossCode %d", tossCode);
			// getting position
			pos = dynamixel.getPosition(&serialPort, idAX12);
			Utils::sleepMS(500);
		} while (tossCode == -1 || !(pos > 250 && pos < 1023));

		do {
			printf("********Welcome to Bioloid API**************\n");
			printf("1. Read Positions\n");
			printf("2. Withdraw Cash\n");
			printf("3. Motor 2 sim\n");
			printf("4. Quit\n");
			printf("******************?**************************?*\n\n");
			printf("Enter your choice: ");
			scanf("%d", &choice);

			if (ii == 1) {
				printf("%d***************\n", ii);
			}


			switch (choice)
			{
			case 1:

				printf("\n Bioloid Dynamixel Positions:");
				int dxlPos[18];
				ii = 1;
				dynamixel.setPosition(&serialPort, 2, 728);
				while (i != 19) {

					int pos = dynamixel.getPosition(&serialPort, ii);
					Utils::sleepMS(50);
					printf(" <%i> %d", pos, ii);
					dxlPos[ii] = pos;
					ii = ii + 1;
					i = ii;
				}
				printf(" \n");

				if (dxlPos[2] > 250 && dxlPos[2] < 1023) {
					printf("Setting position for dxl 2\n");
					dynamixel.setSpeed(&serialPort, 2, 53);
					dynamixel.setPosition(&serialPort, 2, 290);

				}
				else
					printf ("\nPosition <%i> under 250 or over 1023\n", pos);


				break;
			case 2:
				//setting position.
				if (pos > 250 && pos < 1023)
					dynamixel.setPosition(&serialPort, idAX12, pos - 100);
				else
					printf ("\nPosition <%i> under 250 or over 1023\n", pos);

				//Lets read some values:
				load = dynamixel.getLoad(&serialPort, idAX12);
				printf("Load : %d\n", load);

				//Read Torque
				torq = dynamixel.getTorque(&serialPort, idAX12);
				printf("Torque : %d\n", torq);

				//Read Speed
				speed = dynamixel.getCurrentSpeed(&serialPort, idAX12);
				printf("Speed : %d\n", speed);
				break;
			case 3:

				s = time(NULL);
				gettimeofday(&t0, 0);
				do {
					pos = dynamixel.getPosition(&serialPort, 2);
					t = time(NULL);
					gettimeofday(&t1, 0);
					//printf("%s\n", difftime(t,s));
					fprintf(f, "%d  %lf\n", pos, timedifference_msec(t0, t1));
					Utils::sleepMS(100);
				} while (time(NULL) < s + 5);
				fclose(f);
				printf("Aaagara babbuu !!\n" );
				break;
			case 4:
				printf("\n THANK U");
				quitOption = 1;
				break;
			}
		} while (quitOption == 0);
		serialPort.disconnect();
	}
	else {
		printf ("\nCan't open serial port");
		error = -1;
	}

	cout << endl << "AX Control ends" << endl; // prints AX Control
	return error;
}
