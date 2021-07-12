#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char valor1[]={0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x00};
unsigned char valor2[]={0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01, 0x00};


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
    pcf8574_write(0x40, 0x00);
    pcf8574_write(0x42, 0x00);
    pcf8574_write(0x44, 0x00);
    while(1){
        unsigned char x=0;
        for(x=0;x<9;x++){
            pcf8574_write(0x40, valor1[x]);
            __delay_ms(100);
        }
        for(x=0;x<9;x++){
            pcf8574_write(0x42, valor1[x]);
            __delay_ms(100);
        }
        for(x=0;x<9;x++){
            pcf8574_write(0x44, valor1[x]);
            __delay_ms(100);
        }
        for(x=0;x<9;x++){
            pcf8574_write(0x44, valor2[x]);
            __delay_ms(100);
        }
        for(x=0;x<9;x++){
            pcf8574_write(0x42, valor2[x]);
            __delay_ms(100);
        }
        for(x=0;x<9;x++){
            pcf8574_write(0x40, valor2[x]);
            __delay_ms(100);
        }        
    }
}
