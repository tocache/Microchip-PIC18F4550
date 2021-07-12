/*
 * File:   maincode.c
 * Author: Kalun Lau
 *
 * Created on June 9, 2021, 11:42 AM
 */

#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void init_conf(void){
    
}

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
    SSPBUF = 0x40;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = data;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
}

void main(void) {
    init_conf();
    mssp_conf();
    while(1){
        pcf8574_write(0x55);
        __delay_ms(100);
        pcf8574_write(0xAA);
        __delay_ms(100);
    }
}
