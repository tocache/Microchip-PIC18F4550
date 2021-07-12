/*
 * File:   maincode.c
 * Author: Kalun Lau
 *
 * Created on June 9, 2021, 11:42 AM
 */

#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char auto_fan[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02};

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
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0x42;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = data;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
}

void main(void) {
    mssp_conf();
    while(1){
        unsigned char x = 0;
        for(x=0;x<14;x++){
            pcf8574_write(auto_fan[x]);
            __delay_ms(100);
        }
    }
}
