
#include <pic18f4550.h>

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char ad_resultado = 0;
unsigned char centenas = 0;
unsigned char decenas = 0;
unsigned char unidades = 0;
unsigned char ticks = 0;
unsigned char segundos = 55;
unsigned char minutos = 59;
unsigned char horas = 12;
unsigned char am_pm = 1;  //0 es AM y 1 es PM

void configuro(void){
    ADCON2 = 0x24;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
    T1CON = 0x31; 
    CCP1CON = 0x0B;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.CCP1IE = 1;
    CCPR1H = 0xF4;
    CCPR1L = 0x24;
}

void arranque_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(22);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

digit_converter(unsigned char numero){
    centenas = numero / 100;
    decenas = (numero % 100) / 10;
    unidades = numero % 10;
}

void main(void) {
    configuro();
    arranque_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Termoneitor UPC",15);
    while(1){
        ADCON0bits.GO_DONE = 1;
        while(ADCON0bits.GO_DONE);
        ad_resultado = ((ADRESH >> 1) & 0x7F);
        digit_converter(ad_resultado);
        POS_CURSOR(2,0);
//        ESCRIBE_MENSAJE("LM35: ",6);
        ENVIA_CHAR(centenas + 0x30);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C ",2);
        digit_converter(horas);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(':');
        digit_converter(minutos);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(':');
        digit_converter(segundos);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        if(am_pm == 0){
            ESCRIBE_MENSAJE("AM",2);
        }
        else{
            ESCRIBE_MENSAJE("PM",2);
        }
    }
}

void __interrupt(high_priority) CCP1_ISR(void){
    PIR1bits.CCP1IF = 0;
    if(ticks == 15){
        ticks = 0;
        if(segundos == 59){
            segundos = 0;
            if(minutos == 59){
                minutos = 0;
                if(horas == 12){
                    horas = 1;
                }
                else{
                    horas++;
                    if(horas == 12){
                        if(am_pm == 0){
                            am_pm = 1;
                        }
                        else{
                            am_pm = 0;
                        }
                    }
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
    else{
        ticks++;
    }
}
