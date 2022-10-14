#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char horas = 16;
unsigned char minutos = 22;
unsigned char segundos = 37;
unsigned char d_centena = 0;
unsigned char d_decena = 0;
unsigned char d_unidad = 0;
unsigned char reloj[] = {0x0E, 0x15, 0x15, 0x17, 0x11, 0x11, 0x0E, 0x00};
unsigned char pacman[] = {0x0E, 0x11, 0x12, 0x14, 0x12, 0x11, 0x0E, 0x00};

void configuro(void){
    T1CON = 0x0F;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR1IE = 1;
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(20);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(reloj, 0);    
    GENERACARACTER(pacman, 1);      
    
}

void digit_converter(unsigned char numero){
    d_centena = numero / 100;
    d_decena = (numero % 100) / 10;
    d_unidad = numero % 10;
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola UPC Monterr",16);
        POS_CURSOR(2,0);
//        ESCRIBE_MENSAJE("Reloj ",6);
        ENVIA_CHAR(0);
        ENVIA_CHAR(1);        
        ENVIA_CHAR(' ');
        digit_converter(horas);
        ENVIA_CHAR(d_decena + 0x30);
        ENVIA_CHAR(d_unidad + 0x30);
        ENVIA_CHAR(':');
        digit_converter(minutos);
        ENVIA_CHAR(d_decena + 0x30);
        ENVIA_CHAR(d_unidad + 0x30);
        ENVIA_CHAR(':');
        digit_converter(segundos);
        ENVIA_CHAR(d_decena + 0x30);
        ENVIA_CHAR(d_unidad + 0x30);
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
