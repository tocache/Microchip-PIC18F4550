#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char angulo = 180;
float cuentas_ton = 0;
float cuentas_tof = 0;
unsigned char diezmillar = 0;
unsigned char millar = 0;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;
unsigned int previo = 0;

void configuro(void){
    OSCCON = 0x70;      //INTOSC a 8MHz
    TRISEbits.RE0 = 0;  //RE0 como salida
    ADCON1 = 0x0F;      //RE0 como digital
}

void inicializacion_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    diezmillar = numero / 10000;
    millar = (numero % 10000) / 1000;
    centena = (numero % 1000) / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    inicializacion_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Formuleando", 11);
    while(1){
        cuentas_ton = 64136 - (17.78 * angulo);
        convierte(cuentas_ton);
        POS_CURSOR(2,0);
        ENVIA_CHAR(diezmillar + 0x30);
        ENVIA_CHAR(millar + 0x30);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        cuentas_tof = 26936 + (17.78 * angulo);
        convierte(cuentas_tof);
        ENVIA_CHAR(' ');
        ENVIA_CHAR(diezmillar + 0x30);
        ENVIA_CHAR(millar + 0x30);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        previo = cuentas_ton;

    }
}