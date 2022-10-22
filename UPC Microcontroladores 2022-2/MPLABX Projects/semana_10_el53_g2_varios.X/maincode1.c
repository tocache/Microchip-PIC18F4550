#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char mensaje[] = {"                Microcontroladores                "};
unsigned char x = 0;
unsigned char y = 0;
unsigned char resultado_ad;
unsigned char centena,decena,unidad;
unsigned char horas = 18;
unsigned char minutos = 17;
unsigned char segundos = 56;
unsigned char ticks = 0;

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
    __delay_ms(24);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void titulaso(void){
    POS_CURSOR(1,0);
    for(x=0;x<17;x++){
        ENVIA_CHAR(mensaje[x+y]);
    }
    __delay_ms(150);
    if(y == 34){
        y = 0;            
    }
    else{
        y++;
    }
}

void convierte_digitos(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    arranque_LCD();
    while(1){
        titulaso();
        ADCON0bits.GO_DONE = 1;
        while(ADCON0bits.GO_DONE);
        resultado_ad = (ADRESH >> 1) & 0x7F;
        convierte_digitos(resultado_ad);
        POS_CURSOR(2,0);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        ENVIA_CHAR(' ');
        convierte_digitos(horas);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        convierte_digitos(minutos);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(':');
        convierte_digitos(segundos);
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
    else{
        ticks++;
    }
}
