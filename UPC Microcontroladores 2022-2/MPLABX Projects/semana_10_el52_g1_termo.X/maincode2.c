#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char o_acento[]={0x02,0x04,0x0E,0x11,0x11,0x11,0x0E,0x00};
unsigned char res_ad = 0;
unsigned char centenas = 0;
unsigned char decenas = 0;
unsigned char unidades = 0;
unsigned int promedio = 0;

void configuro(void){
    ADCON2 = 0x24;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
}

void arranca_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(o_acento,0);
}

void convierte_digitos(unsigned char numero){
    centenas = numero / 100;
    decenas = (numero % 100) / 10;
    unidades = numero % 10;
}

void main(void) {
    configuro();
    arranca_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Termotr",7);
    ENVIA_CHAR(0);
    ESCRIBE_MENSAJE("n UPCino",8);
    while(1){
        unsigned char i;
        for(i=0;i<20;i++){
            ADCON0bits.GO_DONE = 1;
            while(ADCON0bits.GO_DONE);
            res_ad = ((ADRESH >> 1) & 0x7F);
            promedio = promedio + res_ad;
        }
        promedio = promedio / 20;
        convierte_digitos(promedio);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("LM35:",5);
        ENVIA_CHAR(centenas + 0x30);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
    };
}
