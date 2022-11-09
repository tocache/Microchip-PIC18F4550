#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char efecto[] = {0x01,0x02,0x04,0x02,0x03,0x06,0x00,0x07};
unsigned char estado = 0;
unsigned char LED_OFF[] = {0x0E,0x11,0x11,0x11,0x11,0x0A,0x0E,0x0E};
unsigned char LED_ON[] = {0x0E,0x1F,0x1F,0x1F,0x1F,0x0E,0x0E,0x0E};

void configuro(void){
    OSCCON = 0x70;  //Reloj a 8MHz
    ADCON1 = 0x0F;  //Todos los ANx como digitales
    TRISE = 0xF8;   //RE0:RE2 como salidas
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(16);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(LED_OFF, 0);
    GENERACARACTER(LED_ON, 1);
}

void vis_LED(void){
    POS_CURSOR(2,5);
    if(PORTEbits.RE2 == 0){
        ENVIA_CHAR(0);
    }
    else{
        ENVIA_CHAR(1);
    }
    if(PORTEbits.RE1 == 0){
        ENVIA_CHAR(0);
    }
    else{
        ENVIA_CHAR(1);
    }
    if(PORTEbits.RE0 == 0){
        ENVIA_CHAR(0);
    }
    else{
        ENVIA_CHAR(1);
    }
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 13",9);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("LEDs:",5);
    while(1){
        unsigned char x;
        switch(estado){
            case 0:
                for(x=0;x<4;x++){
                    LATE = efecto[x];
                    vis_LED();
                    __delay_ms(200);                    
                }
                break;
            case 1:
                for(x=4;x<6;x++){
                    LATE = efecto[x];
                    vis_LED();
                    __delay_ms(200);                    
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE = efecto[x];
                    vis_LED();
                    __delay_ms(200);                    
                }
                break;
        }
    }
}

void __interrupt() INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado == 2){
        estado = 0;
    }
    else{
        estado++;
    }
    __delay_ms(90);
}