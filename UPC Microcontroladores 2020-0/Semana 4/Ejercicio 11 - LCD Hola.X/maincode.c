// PIC18F4550 Configuration Bit Settings
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 4000000UL
#include <xc.h>
#include "LCD.h"

unsigned int cuenta = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
unsigned int conversion = 0;

unsigned int digitos(numero){
    millar = numero / 1000;
    centena = (numero - (millar * 1000)) / 100;
    decena = ((numero - (millar * 1000)) - (centena * 100)) / 10;
    unidad = ((numero - (millar * 1000)) - (centena * 100)) - (decena * 10);
}

void main(void) {
    //Configuración inicial para el LCD
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    ADCON2 = 0x14;              //4TAD FOSC/4 ADFM=0
    ADCON1 = 0x0E;              //AN0 analogico
    ADCON0 = 0x01;              //AN0 seleccionado y ADON=1
    CURSOR_HOME();
    ESCRIBE_MENSAJE("Conversion A/D",14);
    while(1){
        ADCON0bits.GODONE = 1;      //iniciar la conversion
        while(ADCON0bits.GODONE);
        digitos(ADRESH);
        POS_CURSOR(2,0);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        __delay_ms(100);
    }
}