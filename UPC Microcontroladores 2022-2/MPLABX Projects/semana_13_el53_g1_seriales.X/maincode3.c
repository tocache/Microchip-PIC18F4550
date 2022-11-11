#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char efecto[]={0x00,0x01,0x00,
                        0x02,0x00,0x04,
                        0x00,0x02,0x01,
                        0x02,0x04,0x02,
                        0x00,0x07,0x02,
                        0x05};
unsigned char estado_f=0;
unsigned char estado_v=0;
unsigned char led_off[]={0x04,0x1F,0x11,
                        0x0A,0x04,0x1F,
                        0x04,0x04};
unsigned char led_on[]={0x04,0x1F,0x1F,
                        0x0E,0x04,0x1F,
                        0x04,0x04};

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISE = 0xF8;
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;
    INTCONbits.GIEL = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON2bits.RBPU = 0;
    INTCON3bits.INT1IE = 1;
    INTCON2bits.INTEDG1 = 0;
    INTCON3bits.INT1IP = 0;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(23);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(led_off,0);
    GENERACARACTER(led_on,1);
}

void delaymon(void){
    switch(estado_v){
        case 0:
            __delay_ms(50);
            break;
        case 1:
            __delay_ms(100);
            break;
        case 2:
            __delay_ms(250);
            break;
        case 3:
            __delay_ms(400);
            break;
    }
}

void vis_LEDs(void){
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("LEDs: ",6);
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
    ESCRIBE_MENSAJE("UPCino Sem13",12);
    while(1){
        switch(estado_f){
            unsigned char x;
            case 0:
                for(x=0;x<8;x++){
                    LATE = efecto[x];
                    vis_LEDs();
                    delaymon();
                }
                break;
            case 1:
                for(x=8;x<12;x++){
                    LATE = efecto[x];
                    vis_LEDs();
                    delaymon();
                }
                break;
            case 2:
                for(x=12;x<14;x++){
                    LATE = efecto[x];
                    vis_LEDs();
                    delaymon();
                }
                break;
            case 3:
                for(x=14;x<16;x++){
                    LATE = efecto[x];
                    vis_LEDs();
                    delaymon();
                }
                break;                
        }        
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado_f == 3){
        estado_f = 0;
    }
    else{
        estado_f++;
    }
}

void __interrupt(low_priority) INT1_ISR(void){
    INTCON3bits.INT1IF = 0;
    if(estado_v == 3){
        estado_v = 0;
    }
    else{
        estado_v++;
    }
}
