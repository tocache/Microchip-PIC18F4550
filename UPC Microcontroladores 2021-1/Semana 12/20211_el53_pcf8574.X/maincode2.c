/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on June 9, 2021, 6:08 PM
 */


#include <xc.h>
#include "configuration.h"
#define _XTAL_FREQ 48000000UL

unsigned char cuenta[]={0x81, 0x42, 0x24, 0x18, 0x24, 0x42};

void mssp_conf(void){
    SSPCON1bits.SSPEN = 1;  //MSSP I2C enabled
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;  //MSSP I2C Master mode
    SSPADD = 119;           //Datarate 100KHz
}

void pcf8574_write(unsigned char data){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);        //condicion START
    SSPBUF = 0x40;                      //envio de direccion esclavo
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);       //ACK
    SSPBUF = data;                      //envio del dato al esclavo
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);       //ACK
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);        //condicion STOP
}

void main(void) {
    mssp_conf();
    while(1){
        unsigned char x =0;
        for(x=0;x<6;x++){
            pcf8574_write(cuenta[x]);
            __delay_ms(100);
        }
    }
}
