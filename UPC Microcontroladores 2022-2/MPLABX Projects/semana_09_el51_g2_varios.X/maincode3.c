#include <xc.h>
#include "cabacera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char horas = 19;
unsigned char minutos = 52;
unsigned char segundos = 36;

unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;
//slash slash para comentarios

void configuro(void){
    T1CON = 0x0F;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR1IE = 1;
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void digitos_individuales(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola UPCino", 11);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Reloj ", 6);
        digitos_individuales(horas);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        digitos_individuales(minutos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        digitos_individuales(segundo);
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
