// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
#pragma config FOSC = INTOSCIO_EC// Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = OFF     // CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

/*Declaración de librerías*/
#include <xc.h>
#include <stdlib.h>
#include <stdio.h>
#include "LCD.h"

/*Delcaración de la velocidad del reloj principal del CPU*/
#define _XTAL_FREQ 8000000UL

int diguni;
int digdec;
int digcen;
int temporal;
int resadc;

void main(void){
    OSCCONbits.IRCF0 = 1;   /*El oscilador interno a 8MHz hacia reloj principal*/
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF2 = 1; 
    TRISD = 0x00;           /*Puerto D como salida, conectado al LCD*/
    
    ADCON2 = 0x24;  /*Justificacion a la izquierda, 8TAD, FOSC/4*/
    ADCON1 = 0x1E;  /*Solo AN0 habilitado*/
    ADCON0 = 0x01;  /*Encendemos el ADC*/
    CVRCON = 0xC0;  /*Habilitamos el módulo de voltaje de referencia del comparador analógico con salida en RA2 y 1.25V*/

    LCD_CONFIG();
    __delay_ms(10);
    BORRAR_LCD();           /*Borramos el LCD*/
    CURSOR_ONOFF(OFF);
    CURSOR_HOME();
    ESCRIBE_MENSAJE("TERMOTRON UPC",13);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("POTENC:",7);
    while(1){
        if (ADCON0bits.GODONE == 0){
            resadc = ADRESH;
            ADCON0bits.GODONE = 1;
        }
        resadc = resadc /2;
        conviertemon();
        POS_CURSOR(2,8);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR(0x43);
        LATDbits.LD3 = 1;
        __delay_ms(100);
        LATDbits.LD3 = 0;
        __delay_ms(100);

    }
}

int conviertemon(void){
        digcen = resadc / 100;
        temporal = resadc - (digcen * 100);
        digdec = temporal / 10;
        diguni = temporal - (digdec * 10);
}