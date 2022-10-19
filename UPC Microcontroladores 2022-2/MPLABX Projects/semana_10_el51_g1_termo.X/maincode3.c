#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;
unsigned char res_ad = 0;
unsigned char horas = 17;
unsigned char minutos = 1;
unsigned char segundos = 52;
unsigned char ticks = 0;

void configuro(void){
    ADCON2 = 0x24;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
    T1CON = 0x31;       //PSC 1:8 y FOSC/4
    CCP1CON = 0x0B;    //Compare special trigger event
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;
    INTCONbits.GIEL = 1;
    PIE1bits.CCP1IE = 1;
    INTCON3bits.INT1IE = 1;
    INTCON3bits.INT2IE = 1;
    INTCON3bits.INT1P = 0;
    INTCON3bits.INT2P = 0;    
    CCPR1H = 0xF4;
    CCPR1L = 0x24;
}

void arranque_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(17);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void digit_converter (unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    arranque_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Termo-Reloj UPC",15);
    while(1){
        ADCON0bits.GO_DONE = 1;
        while(ADCON0bits.GO_DONE == 1);
        res_ad = ((ADRESH >> 1) & 0x7F);
        digit_converter(res_ad);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE(" ", 1);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C  ", 3);
        digit_converter(horas);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        digit_converter(minutos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':'); 
        digit_converter(segundos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);        
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
                if(horas == 23){
                    horas = 0;}
                else{horas++;}
            }
            else{minutos++;}
        }
        else{segundos++;}
    }
    else{ticks++;}
}

void __interrupt(low_priority) INT12_ISR(void){
    if(INTCON3bits.INT1IF == 1){
        INTCON3bits.INT1F = 0;
        if(horas == 23){
            horas = 0;}
        else{horas++;}         
    }
    if(INTCON3bits.INT2IF == 1){
        INTCON3bits.INT2F = 0;
        if(minutos == 59){
            minutos = 0;}
        else{minutos++;}         
    }
}