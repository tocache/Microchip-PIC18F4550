#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char centenas = 0;
unsigned char decenas = 0;
unsigned char unidades = 0;
unsigned char res_adc = 0;
unsigned char horas = 12;
unsigned char minutos = 59;
unsigned char segundos = 55;
unsigned char ticks = 0;
unsigned char am_pm = 0;

void configuro(void){
    ADCON2 = 0x24;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
    T1CON = 0x35;
    CCP1CON = 0x0B;
    CCPR1H = 0xF4;
    CCPR1L = 0x24;
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;
    INTCONbits.GIEL = 1;
    PIE1bits.CCP1IE = 1;
    INTCON3bits.INT1IP = 0;
    INTCON3bits.INT2IP = 0;
    INTCON3bits.INT1IE = 1;
    INTCON3bits.INT2IE = 1;
            
}

void arranca_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(19);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
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
    ESCRIBE_MENSAJE(" Termometro UPC",15);
    while(1){
        ADCON0bits.GO_DONE = 1;
        while(ADCON0bits.GO_DONE == 1);
        //Ya tengo el resultado del A/D en ADRESH:ADRESL
        res_adc = (ADRESH >> 1) & 0x7F;
        convierte_digitos(res_adc);
        POS_CURSOR(2,0);
        ENVIA_CHAR(centenas + 0x30);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C ",2);
        convierte_digitos(horas);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(':');
        convierte_digitos(minutos);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(':');
        convierte_digitos(segundos);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        if(am_pm == 1){
            ESCRIBE_MENSAJE("PM", 2);
        }
        else{
            ESCRIBE_MENSAJE("AM", 2);            
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
                    //pendiente para am_pm
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

void __interrupt(low_priority) INTs_ISR(void){
    if(INTCON3bits.INT1IF == 1){
        INTCON3bits.INT1IF = 0;
        if(horas == 12){
            horas = 1;
        }
        else{
            horas++;
            //pendiente para am_pm
        }
    }
    if(INTCON3bits.INT2IF == 1){
        INTCON3bits.INT2IF = 0;
        if(minutos == 59){
            minutos = 0;
        }
        else{
            minutos++;
            //pendiente para am_pm
        }
    }
    
}
