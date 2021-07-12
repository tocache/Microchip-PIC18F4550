/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on June 10, 2021, 2:42 PM
 */

/*  1. condicion START
    2. enviar direccion slave
    3. esperar Ack
    4. enviar dato
    5. esperar Ack
    6. condicion STOP*/


#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char cuenta = 0;

void mssp_conf(void){
    SSPCON1bits.SSPEN = 1;      //habilitar el MSSP
    SSPCON1bits.SSPM = 0b1000;  //MSSP en modo i2c maestro
    SSPADD = 119;               //datarate 100k
}


void pcf8574_write(unsigned char direccion, unsigned char dato){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);    //(1)cond.Start
    SSPBUF = direccion;             //(2)slaveaddr+Wr
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);   //(3)ACK
    SSPBUF = dato;                  //(4)datasend
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);   //(5)ACK
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);    //(6)cond.Stop    
}

void main(void) {
    mssp_conf();
    while(1){
        pcf8574_write(0x40, cuenta);
        cuenta++;
        __delay_ms(100);
    }
}
