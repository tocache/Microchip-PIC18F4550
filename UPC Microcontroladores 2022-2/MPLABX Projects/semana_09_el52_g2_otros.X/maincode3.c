#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char horas = 20;
unsigned char minutos = 13;
unsigned char segundos = 37;
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro(void){
    TRISBbits.RB0 = 0;
    T1CON = 0x0F;
    PIE1bits.TMR1IE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
}

void digitos(unsigned char numero){
    decena = numero / 10;
    unidad = numero % 10;
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(25);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        LATBbits.LB0 = 1;
        __delay_ms(100);
        LATBbits.LB0 = 0;
        __delay_ms(100);
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Buenas noches", 13);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Reloj ", 6);
        digitos(horas);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);        
        ENVIA_CHAR(':');
        digitos(minutos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);        
        ENVIA_CHAR(':');
        digitos(segundos);
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

        