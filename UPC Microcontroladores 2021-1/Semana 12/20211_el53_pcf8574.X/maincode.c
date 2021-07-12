/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on June 9, 2021, 6:08 PM
 */


#include <xc.h>
#include "configuration.h"
#define _XTAL_FREQ 48000000UL

unsigned char cuenta = 0;

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
        for(cuenta=0;cuenta<100;cuenta++){
            pcf8574_write(cuenta);
            __delay_ms(100);
        }
    }
}
