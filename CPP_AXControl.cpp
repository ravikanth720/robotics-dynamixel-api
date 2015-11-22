//============================================================================
// Name        : CPP_AXControl.cpp
// Author      : JCA
// Version     :
// Copyright   : GPL
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
using namespace std;
#include <fstream>
#include "SerialPort.h"
#include "Dynamixel.h"
#include "Utils.h"
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
	cout << "AX Control starts" << endl; // prints AX Control

	int error=0;
	int idAX12=18;
	int tossCode=0;
	int pos;
	int speed;
	int torq;
	int load;
	int i=1;
	FILE *f = fopen("positions.txt", "w");

	time_t t;
//
	SerialPort serialPort;
	Dynamixel dynamixel;
//
//
	if (serialPort.connect("/dev/ttyUSB0")!=0) {
		//keep trying to sendTossModeCommand till pos value is right.
		t = time(NULL) + 5;

		tossCode =  dynamixel.sendTossModeCommand(&serialPort);

		do{

		for(i=1;i<19;i++)
				{


		//	pos = dynamixel.getPosition(&serialPort, i);
			speed = dynamixel.getCurrentSpeed(&serialPort, i);
		//	torq = dynamixel.getTorque(&serialPort, i);
		//	load = dynamixel.getLoad(&serialPort, i);
			fprintf(f, "%d ", speed);
		}
		for(i=1;i<19;i++)
				{
			pos = dynamixel.getPosition(&serialPort, i);
		//	speed = dynamixel.getCurrentSpeed(&serialPort, i);
		//	torq = dynamixel.getTorque(&serialPort, i);
		//	load = dynamixel.getLoad(&serialPort, i);
			fprintf(f, "%d ", pos);
		}

fprintf(f, "\n");
}while(time(NULL) < t);
fclose(f);
printf("Aaagara babbuu !!\n" );
Utils::sleepMS(5000);
// FILE *fp;
char * line = NULL;
size_t len = 0;
ssize_t read;
char * motorparams = NULL;
int spd = 0;
FILE *fp =  fopen("positions.txt", "r");
char *val;
char *ch[256];
i=0;
int k;
int j=0;

while ((read = getline(&line, &len, fp)) != -1) {
           printf("Retrieved line of length %zu :\n", read);

          //  printf("%s", line);
					ch[i]  = strtok(line," ");

					int dxlnum = 1;
					j=0;
					while(ch[i] != NULL ){
						 printf("  %s  -- %i",ch[i],j);

						 j=j+1;
						 if(j==19){
							 dxlnum=1;
						 }

						 if(j<19){
							 dynamixel.setSpeed(&serialPort,dxlnum, atoi(ch[i]));
							 printf("\n*** %d\n",dxlnum);
						 }
						 else if (j>18){
							 dynamixel.setPosition(&serialPort,dxlnum, atoi(ch[i]));
						 }
						 printf("------------------------- !!!!!!\n");
						 dxlnum =dxlnum+1;
						 i=i+1;
					 	 ch[i] = strtok(NULL," ");
					}
					Utils::sleepMS(1000);
					// // printf("--------------------------------------------------------------\n");
					//
					// for(;j<i;j++){
					//
					// 	 printf("================================>%i  --- %i , %i",dxlnum,i,j);
					//
					// 	 if(!ch[j])
					// 	 	printf("<<==============got NULL =======>>>\n");
					// // 	//printf("------------------------------------------------------------+++++++++++--\n");
					//  	printf("\n***  -> %s \n",ch[j]);
					// // 	//printf("----------------------------------------------------------++++++++-\n");
					// 	val=NULL;
					// 	val = strtok(ch[j],":");
					//  printf("%s:",val );
					// //  if(atoi(val)>=0 )
					// //     dynamixel.setSpeed(&serialPort,dxlnum, 10);
					//  //Utils::sleepMS(100);
					//  val = strtok(NULL,":");
					//  printf("%s:",val );
					// //  if(atoi(val)>0 )
					//  dynamixel.setPosition(&serialPort,dxlnum,atoi(val));
					//  Utils::sleepMS(100);
					// //  val = strtok(NULL,":");
					// //  printf("%s:",val );
					// //  //dynamixel.setTorque(&serialPort,dxlnum,atoi(val));
					// //  val = strtok(NULL,":");
					// //  printf("%s:  ",val );
					//  dxlnum=dxlnum+1;
					//
					//  }
					 printf("\n");
					 //	Utils::sleepMS(100);
       }

		serialPort.disconnect();
	}
	else {
		printf ("\nCan't open serial port");
		error=-1;
	}

	cout << endl << "AX Control ends" << endl; // prints AX Control
	return error;
}
