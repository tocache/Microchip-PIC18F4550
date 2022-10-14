/*
 * File:   maincode.c
 * Author: Alumnos
 *
 * Created on October 14, 2022, 10:12 AM
 */

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL
//conf hora actual:
unsigned char horas = 12;
unsigned char minutos = 36;
unsigned char segundos = 39;
//vars de indiv de digits
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro(void){
    TRISBbits.RB0 = 0;
    T1CON = 0x0F;
    T1CONbits.T1OSCEN = 0;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR1IE = 1;
}

void LCD_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(20);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned char numero){
    decena = numero / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    LCD_init();
    while(1){
/*        LATBbits.LB0 = 1;
        __delay_ms(100);
        LATBbits.LB0 = 0;
        __delay_ms(100);*/
        if(horas == 12 && minutos ==37){
            LATBbits.LATB0 = 1;
        }
        else{
            LATBbits.LATB0 = 0;
        }
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Viernes Cultural",16);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Reloj ",6);
        convierte(horas);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        convierte(minutos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        convierte(segundos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
    }
}

void __interrupt(high_priority) TMR1_ISR(void){
    PIR1bits.TMR1IF = 0;
    TMR1H = 0x80;
    TMR1L = 0x00;
    if(segundos == 59){
        segundos = 0;
        if(minutos == 59){
            minutos = 0;
            if(horas == 23){
                horas = 0;
            }
            else{
                horas++;
            }
        }
        else{
            minutos++;
        }
    }
    else{
        segundos++;
    }
}
