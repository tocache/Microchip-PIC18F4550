/*Este es el primer ejemplo*/

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char horas = 16;
unsigned char minutos = 52;
unsigned char segundos = 43;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro(void){
    T1CON = 0x0F;
    PIE1bits.TMR1IE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
}

void individualizar_digitos(unsigned char entrada){
    centena = entrada / 100;
    decena = (entrada % 100) / 10;
    unidad = entrada % 10;
}

void lcd_init(void){
    TRISD = 0x00;       //RD todos como salidas
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void){
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1,1);
        ESCRIBE_MENSAJE("Hola UPC",8);

        POS_CURSOR(2,1);
        ESCRIBE_MENSAJE("Reloj ",6);
        individualizar_digitos(horas);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(':');
        individualizar_digitos(minutos);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(':');
        individualizar_digitos(segundos);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
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
