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

const float speed_constant = 5264.785241;


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
	FILE *ft;
	struct BioloidState *bs_initial;
	struct setNextPos *snp_init;
	struct BioloidState *bs_prev;
	struct BioloidState *bs;
	char *ch;
	char *ch2;
	char * line = NULL;
	char * line2 = NULL;
	int prevPositions[18];
	double prevTimestamps[18];
	int currPos;
	double currTime;
	int  currSpeed;
	double deltaT ;
	int deltaD;
	int k = 0;
	size_t len = 0;
	ssize_t read;
	size_t len2 = 0;
	ssize_t read2;
	bool flip = false;
	int spos = 0;
	int sprevpos = 0;
	float stime = 0.0;
	float sprevtime = 0.0;
	int sr_speed = 0;
	int sr_cur_speed = 0;
	int mr_cur_speed = 0;
	float speed_scaling_factor = 1.0f;
	int num_line=0;

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
			printf("1. Record the robot movements \n");
			printf("2. Replay 1 - Imitation Learning with Speed \n");
			printf("3. Replay 2 - Imitation Learning\n");
			printf("4. Read New Initial Positions\n");
			printf("5. Replay from DMP output\n");
			printf("6. Testing - reading from each motor \n");
			printf("7. Testing - writing to each motor \n");
			printf("8. Exit \n");
			printf("******************?***************************\n\n");
			printf("Enter your choice: ");
			scanf("%d", &choice);


			for (k = 0; k < 18; k++) {
				prevPositions[k] = -1;
			}

			switch (choice)
			{
				case 1: //Imitaion learning all motors // reading pos, speed and time from all motors
					printf("In case 6\n");
					f = fopen("movement.txt", "w");
					ft = fopen("positions.txt", "w");
					// TODO - make a seperate function -- ReadBioloidState()
					s = time(NULL);
					gettimeofday(&t0, 0);
					do {
						for (i = 1; i <= 18; i++) {
							pos = dynamixel.getPosition(&serialPort, i);
							mr_cur_speed = dynamixel.getCurrentSpeed(&serialPort, i);
							t = time(NULL);
							gettimeofday(&t1, 0);
							//printf("%s\n", difftime(t,s));
							tm = timedifference_msec(t0, t1);
							t0 = t1;
							fprintf(f, "%d %d %lf ", pos, mr_cur_speed, tm);
							fprintf(ft, "%d ", pos);
						}
						fprintf(f, "\n");
						fprintf(ft, "\n");
						Utils::sleepMS(50);
					} while (time(NULL) < s + 10);

					fclose(f);
					fclose(ft);
					printf("Aaagara babbuu !!\n" );
					break;


					case 2:
						f = fopen("movement.txt", "r");

						i = 0;
						for (i = 1; i < 19; i++) {
							dynamixel.setSpeed(&serialPort, i, 150);
						}
						while ((read = getline(&line, &len, f)) != -1) {
							//printf("%s\n", line );
							i = 0;
							ch  = strtok(line, " ");
							while (ch != NULL ) {
								i = i + 1;
								spos  = atoi(ch);
								ch = strtok(NULL, " ");
								currSpeed = (int)(atoi(ch) * speed_scaling_factor);
								ch = strtok(NULL, " ");
								stime = (float)atof(ch);
								ch = strtok(NULL, " \n");


								printf("%d, %d    %f \n", spos, currSpeed, stime );
								//if (sprevtime != 0.0f) {
								//	deltaT = stime - sprevtime ;
								//		deltaD  = spos - sprevpos;
								//}
								// if (currSpeed > 0)

								if (spos > -1)
									dynamixel.setPosition(&serialPort, i, spos);
								//if (sprevtime == 0.0) {
								//	Utils::sleepMS(3000);
								//}
								//sprevtime = stime;
								//sprevpos = spos;
								//ch = strtok(NULL, " ");
							}
							Utils::sleepMS(50 );
						}
						fclose(f);
						break;

						case 3: //write only positions to robot
							ft = fopen("positions.txt", "r");
							num_line=0;
							//ft = fopen("/home/ravitejas3/Documents/robotics/FinalProjectCode/myDMPImpl/dmp_positions.txt", "r");

							for (i = 1; i < 19; i++) {
								dynamixel.setSpeed(&serialPort, i, 150);
							}
							while ((read = getline(&line, &len, ft)) != -1) {
								//printf("%s\n", line );
								i = 0;
								ch  = strtok(line, " ");
								while (ch != NULL ) {
									i = i + 1;
									spos  = atoi(ch);
									ch = strtok(NULL, " ");
									//dynamixel.setSpeed(&serialPort, i, 100);
									if (spos > -1)
										dynamixel.setPosition(&serialPort, i, spos);
								}
								if(num_line==0){
									Utils::sleepMS(3000);
									num_line=1;

								}
							}
							fclose(ft);
							break;
				case 4: //read initial state values from all motors
					printf("In case 10\n");
					ft = fopen("initial_position.txt", "w");
					for (i = 1; i <= 18; i++) {
						pos = dynamixel.getPosition(&serialPort, i);
						fprintf(ft, "%d ", pos);
					}
					fclose(ft);
					break;


					case 5: //write only positions to robot
						ft = fopen("dmp_final.txt", "r");
						num_line=0;
						//ft = fopen("/home/ravitejas3/Documents/robotics/FinalProjectCode/myDMPImpl/dmp_positions.txt", "r");

						for (i = 1; i < 19; i++) {
							dynamixel.setSpeed(&serialPort, i, 150);
						}
						while ((read = getline(&line, &len, ft)) != -1) {
							//printf("%s\n", line );
							i = 0;
							ch  = strtok(line, " ");
							while (ch != NULL ) {
								i = i + 1;
								spos  = atoi(ch);
								ch = strtok(NULL, " ");
								//dynamixel.setSpeed(&serialPort, i, 100);
								if (spos > -1)
									dynamixel.setPosition(&serialPort, i, spos);
							}
							//Utils::sleepMS(1);
							if(num_line==0){
								Utils::sleepMS(3000);
								num_line=1;

							}
						}
						fclose(ft);
						break;

						case 6: // reading values from single motor

							f = fopen("singlepositions.txt", "w");
							s = time(NULL);
							gettimeofday(&t0, 0);
							do {
								pos = dynamixel.getPosition(&serialPort, 2);
								sr_speed = dynamixel.getSpeed(&serialPort, 2);
								sr_cur_speed = dynamixel.getCurrentSpeed(&serialPort, 2);
								t = time(NULL);
								gettimeofday(&t1, 0);
								fprintf(f, "%d %d %d %lf\n", pos, sr_cur_speed, sr_speed, timedifference_msec(t0, t1));
								Utils::sleepMS(10);
							} while (time(NULL) < s + 5);
							fclose(f);
							printf("Aaagara babbuu !!\n" );
							break;

							case 7:
								f = fopen("singlepositions.txt", "r");
								while ((read = getline(&line, &len, f)) != -1) {
									ch  = strtok(line, " ");
									while (ch != NULL ) {
										spos  = atoi(ch);
										ch = strtok(NULL, " ");
										currSpeed = atoi(ch);
										ch = strtok(NULL, " ");
										ch = strtok(NULL, " ");
										stime = (float)atof(ch);
										printf("%d, %d    %f \n", spos, currSpeed, stime );
										if (sprevtime != 0.0f) {
											deltaT = stime - sprevtime ;
											deltaD  = spos - sprevpos;
											// printf(" %f\n", (abs(deltaD) / deltaT) * speed_constant );
											// currSpeed =  ((deltaD) / deltaT) * speed_constant ;
											// printf("-------------------------> %d %f -> %f \n", spos, (stime -  sprevtime), currSpeed );
											//dynamixel.setSpeed(&serialPort, 2, (int)abs(currSpeed));
											//dynamixel.setSpeed(&serialPort, 2, 0);
											//dynamixel.getSpeed(&serialPort,2);

										}
										dynamixel.setSpeed(&serialPort, 2, currSpeed);
										dynamixel.setPosition(&serialPort, 2, spos);
										if (sprevtime == 0.0) {
											Utils::sleepMS(3000);
										}
										if (deltaT > 10)
											Utils::sleepMS((int)deltaT - 10);
										sprevtime = stime;
										sprevpos = spos;
										ch = strtok(NULL, " ");
									}
								}
								break;

							case 8: // Quit
								printf("\n THANK U");
								quitOption = 1;
								break;

			//===============================================================================
			case 9:// Read the positions and save them to a file
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
			case 10: // Replay from previous step --> positions file
				//setting position.
				f = fopen("positions.txt", "r");
				while ((read = getline(&line, &len, f)) != -1) {
					printf("%s\n", line );
					ch  = strtok(line, " ");
					i = 0;
					printf("-%s-\n", ch );
					flip = true;
					while (ch != NULL ) {
						// printf("-->>" );
						if (flip) {
							currPos = (int)atof(ch);

							printf("[%d] [%d] %d ", currPos, prevPositions[i], i);
							flip = false;
						} else {
							currTime = (float) atof(ch);
							printf("{%f} ", currTime);
							flip = true;
						}

						//	ch = strtok(NULL, " ");
//						ch = strtok(NULL, " ");
						//	currTime = atof(ch);
						//	printf("%lf ", currTime);
						ch = strtok(NULL, " ");
						//printf("%d %f ",currPos,currTime );
						//ch = strtok(NULL, " ");
						if (flip && i != 0) {
							//printf("\nPOS---- %d , %d,%i\n", currPos, prevPo	sitions[i], i);
							//printf("\nTIME----!!!!! %f , %f,%i\n", currTime, prevTimestamps[i], i);
							deltaD = abs(currPos - prevPositions[i]);
							//deltaT = (float) ((float)currTime - (float)prevTimestamps[i]);
							printf("----XX %d %f\n", deltaD, currTime);
							currSpeed = ceil((deltaD / (float)currTime) * speed_constant);
							printf("---->>>>%d\n", currSpeed);
						}
						if (flip) {
							i = i + 1;
							prevPositions[i] = currPos;
							prevTimestamps[i] = currTime;
							printf("------>>>>>> final : %d %d\n", currPos, currSpeed );

							dynamixel.setSpeed(&serialPort, i, currSpeed);
							dynamixel.setPosition(&serialPort, i, int(currPos));

						}

					}
					if (currTime > 200)
						Utils::sleepMS((int)currTime - 200);
					printf("END \n");

				}
				fclose(f);
				break;


			case 11: //Imitaion learning all motors // reading pos, speed and time from all motors

				printf("In case 5\n");
				f = fopen("movement.txt", "w");
				ft = fopen("positions.txt", "w");
				bs_prev = (struct BioloidState *) malloc( sizeof(struct BioloidState) );
// TODO - make a seperate function -- ReadBioloidState()
				s = time(NULL);
				gettimeofday(&t0, 0);
				for (i = 1; i <= 18; i++) {
					printf("Getting initial state %d", i);
					pos = dynamixel.getPosition(&serialPort, i);
					mr_cur_speed = dynamixel.getCurrentSpeed(&serialPort, i);
					bs_prev->pos[i - 1] = pos;
					t = time(NULL);
					gettimeofday(&t1, 0);
					//printf("%s\n", difftime(t,s));
					tm = timedifference_msec(t0, t1);
					t0 = t1;
					bs_prev->tm[i - 1] = tm;
					bs_prev->next = (
					                    struct BioloidState *) malloc( sizeof(struct BioloidState) );
					fprintf(f, "%d %d %lf ", pos, mr_cur_speed, tm);
					fprintf(ft, "%d ", pos);
				}
				fprintf(f, "\n");
				fprintf(ft, "\n");
				Utils::sleepMS(100);
				bs_initial = bs_prev;
				do {
					for (i = 1; i <= 18; i++) {
						bs = bs_prev->next;
						pos = dynamixel.getPosition(&serialPort, i);
						mr_cur_speed = dynamixel.getCurrentSpeed(&serialPort, i);
						bs->pos[i - 1] = pos;
						t = time(NULL);
						gettimeofday(&t1, 0);
						//printf("%s\n", difftime(t,s));
						tm = timedifference_msec(t0, t1);
						t0 = t1;
						bs->tm[i - 1] = tm;
						fprintf(f, "%d %d %lf ", pos, mr_cur_speed, tm);
						fprintf(ft, "%d ", pos);
						bs->next = (struct BioloidState *) malloc( sizeof(struct BioloidState) );
						bs_prev = bs;
					}
					fprintf(f, "\n");
					fprintf(ft, "\n");
				} while (time(NULL) < s + 20);
				fclose(f);
				fclose(ft);
				printf("Aaagara babbuu !!\n" );
				break;



			case 12:// remove
				f = fopen("movement.txt", "r");
				while ((read = getline(&line, &len, f)) != -1) {
					//printf("%s\n", line );
					//read2 = getline(&line2, &len2, ft);
					i = 0;
					ch  = strtok(line, " ");
					//ch2 = strtok(line2, " ");
					while (ch != NULL ) {
						i = i + 1;
						// ch2 = strtok(NULL, " ");
						spos  = atoi(ch);
						//spos  = atoi(ch2);
						ch = strtok(NULL, " ");

						currSpeed = atoi(ch);
						ch = strtok(NULL, " ");
						stime = (float)atof(ch);
						ch = strtok(NULL, " \n");
						//ch2 = strtok(NULL, " \n");


						printf("%d, %d    %f \n", spos, currSpeed, stime );
						// if (sprevtime != 0.0f) {
						// 	deltaT = stime - sprevtime ;
						// 	deltaD  = spos - sprevpos;
						// }
						if (currSpeed > 0)
							dynamixel.setSpeed(&serialPort, i, currSpeed);
						if (spos > -1)
							dynamixel.setPosition(&serialPort, i, spos);
						// if (sprevtime == 0.0) {
						// 	Utils::sleepMS(3000);
						// }
						// sprevtime = stime;
						// sprevpos = spos;
						//ch = strtok(NULL, " ");
					}
					Utils::sleepMS((int)stime);
				}
				fclose(f);
				fclose(ft);

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
