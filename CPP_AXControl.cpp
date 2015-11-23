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
#include <stdlib.h>
#include <string.h>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

float timedifference_msec(struct timeval t0, struct timeval t1)
{
	return (t1.tv_sec - t0.tv_sec) * 1000.0f + (t1.tv_usec - t0.tv_usec) / 1000.0f;
}

const float speed_constant = 52547.85241;


struct BioloidState {
	int pos[18];
	double tm[18];
	struct BioloidState *next;
};

struct setNextPos {
	int pos[18];
	int spd[18];
	double time_unit;
	struct setNextPos *next;
};

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
	double tm;
	SerialPort serialPort;
	Dynamixel dynamixel;
	int quitOption = 0;
	time_t s, t;
	FILE *f;
	struct BioloidState *bs_initial;
	struct setNextPos *snp_init;
	struct BioloidState *bs_prev;
	struct BioloidState *bs;
	char *ch;
	char * line = NULL;
	int prevPositions[18];
	float prevTimestamps[18];
	float currPos, currTime;
	int  currSpeed;
	float deltaT = 0, deltaD;
	int k = 0;
	size_t len = 0;
	ssize_t read;

	//setting initial values

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
			printf("1. Imitation learning \n");
			printf("2. Replay last imitation \n");
			printf("3. Come to initial position \n");
			printf("4. Quit \n");
			printf("******************?**************************?*\n\n");
			printf("Enter your choice: ");
			scanf("%d", &choice);

			if (ii == 1) {
				printf("%d***************\n", ii);
			}
			for (k = 0; k < 18; k++) {
				prevPositions[k] = -1;
			}

			switch (choice)
			{

			case 1:// Read the positions and save them to a file

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
			case 2: // Replay from previous step --> positions file
				//setting position.
				f = fopen("positions.txt", "r");

				while ((read = getline(&line, &len, f)) != -1) {
					ch  = strtok(line, " ");
					i = 0;
					//printf("%s\n",ch );
					while (ch != NULL ) {
						currPos = atof(ch);
						ch = strtok(NULL, " ");
						currTime = atof(ch);
						ch = strtok(NULL, " ");
						if (prevPositions[i] != -1) {

							deltaD = abs(currPos - prevPositions[i]);
							deltaT = currTime - prevTimestamps[i];

							currSpeed = (int)ceil(((float)deltaD / (float)deltaT) * speed_constant);
							printf("---->>>>%d\n", currSpeed);

							dynamixel.setSpeed(&serialPort, 2, currSpeed);
						}

						dynamixel.setPosition(&serialPort, 2, int(currPos));
						prevPositions[i] = (int)currPos;
						prevTimestamps[i] = currTime;
						i = i + 1;

					}
					if (deltaT > 20)
						Utils::sleepMS((int)deltaT - 20);
				}
				break;
			case 3:// Do this later
				f = fopen("positions.txt", "w");
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
			case 4: // Quit
				printf("\n THANK U");
				quitOption = 1;
				break;
			case 5: //Imitaion learning all motors
				printf("In case 5");
				bs_prev = (struct BioloidState *) malloc( sizeof(struct BioloidState) );
// TODO - make a seperate function -- ReadBioloidState()
				s = time(NULL);
				gettimeofday(&t0, 0);
				for(i=1; i<=18; i++){
					printf("Setting initial state");
					pos = dynamixel.getPosition(&serialPort, i);
					bs_prev->pos[i-1] = pos;
					t = time(NULL);
					gettimeofday(&t1, 0);
					//printf("%s\n", difftime(t,s));
					tm = timedifference_msec(t0, t1);
					t0 = t1;
					bs_prev->tm[i-1] = tm;
					bs_prev->next = (struct BioloidState *) malloc( sizeof(struct BioloidState) );
					fprintf(f, "%d  %lf ", pos, tm);
				}
				fprintf(f, "\n");
				Utils::sleepMS(90);
				bs_initial = bs_prev;
				do {
					printf("Here we go again");
					for(i=1; i<=18; i++){
						bs = bs_prev->next;
						pos = dynamixel.getPosition(&serialPort, i);
						bs->pos[i-1] = pos;
						t = time(NULL);
						gettimeofday(&t1, 0);
						//printf("%s\n", difftime(t,s));
						tm = timedifference_msec(t0, t1);
						t0 = t1;
						bs->tm[i-1] = tm;
						fprintf(f, "%d  %lf ", pos, tm);
						bs->next = (struct BioloidState *) malloc( sizeof(struct BioloidState) );
						bs_prev = bs;
					}
					fprintf(f, "\n");
					Utils::sleepMS(90);
				} while (time(NULL) < s + 10);
				fclose(f);
				printf("Aaagara babbuu !!\n" );
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
