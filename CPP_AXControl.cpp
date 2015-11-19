//============================================================================
// Name : CPP_AXControl.cpp
// Author  : JCA
// Version :
// Copyright  : GPL
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
        tossCode = dynamixel.sendTossModeCommand(&serialPort);
        do{
            for(i=1;i<19;i++)
            do{
                printf("n tossCode %d",tossCode);
                // getting position
                Utils::sleepMS(50);
                pos = dynamixel.getPosition(&serialPort, i);
                speed = dynamixel.getCurrentSpeed(&serialPort, i);
                torq = dynamixel.getTorque(&serialPort, i);
                load = dynamixel.getLoad(&serialPort, i);
                fprintf(f, "%d:%d:%d:%d: ", pos, speed, torq, load);
            } while(tossCode==-1);
            fprintf(f, "n");
        }while(time(NULL) < t);
        fclose(f);
        printf("Aaagara babbuu !!n" );
        Utils::sleepMS(5000);
        // FILE *fp;
        char * line = NULL;
        size_t len = 0;
        ssize_t read;
        char * motorparams = NULL;
        int spd = 0;
        FILE *fp = fopen("positions.txt", "r");
        char *val;
        char *ch[256];
        i=0;
        int k;
        int j=0;
        while ((read = getline(&line, &len, fp)) != -1) {
            printf("Retrieved line of length %zu :n", read);
            // printf("%s", line);
            ch[i] = strtok(line," ");
            while(ch[i] != NULL ){
                //
                //
                //got to next motor
                printf(" %s ",ch[i]);
                //dynamixel.setLoad(&serialPort,dxlnum,atoi(val));
                i=i+1;
                ch[i] = strtok(NULL," ,");
            }
            // printf("--------------------------------------------------------------n");
            int dxlnum = 1;
            k = j+18;
            for(;j<i;j++){
                printf("================================>%i --- %i , %i",dxlnum,i,j);
                if(!ch[j])
                printf("<<==============got NULL =======>>>n");
                // //printf("------------------------------------------------------------+++++++++++--n");
                printf("n*** -> %s n",ch[j]);
                // //printf("----------------------------------------------------------++++++++-n");
                val=NULL;
                val = strtok(ch[j],":");
                printf("%s:",val );
                if(atoi(val)>0 )
                dynamixel.setPosition(&serialPort,dxlnum,atoi(val));
                val = strtok(NULL,":");
                printf("%s:",val );
                // if(atoi(val)>0 )
                //  dynamixel.setSpeed(&serialPort,dxlnum,atoi(val));
                val = strtok(NULL,":");
                printf("%s:",val );
                //dynamixel.setTorque(&serialPort,dxlnum,atoi(val));
                val = strtok(NULL,":");
                printf("%s: ",val );
                dxlnum=dxlnum+1;
            }
            printf("n");
            Utils::sleepMS(100);
        }
        // setting position.
        // if (pos>250 && pos <1023)
        // dynamixel.setPosition(&serialPort, idAX12, pos-100);
        // else
        // printf ("nPosition <%i> under 250 or over 1023n", pos);
        //Lets read some values:
        /*
        int load = dynamixel.getLoad(&serialPort,idAX12);
        printf("Load : %dn", load);
        //Read Torque
        int torq = dynamixel.getTorque(&serialPort,idAX12);
        printf("Torque : %dn", torq);
        //Read Speed
        int speed = dynamixel.getCurrentSpeed(&serialPort,idAX12);
        printf("Speed : %dn", speed);
        */
        serialPort.disconnect();
    }
    else {
        printf ("nCan't open serial port");
        error=-1;
    }
    cout << endl << "AX Control ends" << endl; // prints AX Control
    return error;
}
