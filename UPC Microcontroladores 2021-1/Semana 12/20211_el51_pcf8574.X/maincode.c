/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on June 9, 2021, 9:11 PM
 */

#include <xc.h>
#include "cabecera.h"
#define XTAL_FREQ 48000000UL

void mssp_conf(void){
    SSPCON1bits.SSPEN = 1;  //MSSP I2C enabled
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;  //MSSP I2C Master mode
    SSPADD = 119;           //Datarate 100KHz
}

void pcf8574_write(unsigned char address, unsigned char data_out){
/*(1)cond.Start, (2)slaveaddr+Wr, (3)ACK, (4)datasend, (5)ACK, (6)cond.Stop*/
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);    //(1)cond.Start
    SSPBUF = address;               //(2)slaveaddr+Wr
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);   //(3)ACK
    SSPBUF = data_out;              //(4)datasend
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);   //(5)ACK
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);    //(6)cond.Stop
}

//PCF8574-1 0x40
//PCF8574-2 0x42

void main(void) {
    mssp_conf();
    while(1){
        pcf8574_write(0x40, 0x5A);
        pcf8574_write(0x42, 0xA5);
    }
}
