#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char salida[]={0x01,0x02,0x04,0x02,0x05,0x02,0x03,0x06,0x00,0x07};
unsigned char foco_off[]={0x0E,0x11,0x11,0x11,0x11,0x0A,0x0A,0x0E};
unsigned char foco_on[]={0x0E,0x15,0x1F,0x1F,0x15,0x0E,0x0A,0x0E};
unsigned char estado1=0;

void configuro(void){
    OSCCON = 0x70;  //reloj a 8MHz
    ADCON1 = 0x0F;  //ANx como digitales
    TRISE = 0xF8;   //RE2:RE0 como salidas
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(18);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(foco_off,0);
    GENERACARACTER(foco_on,1);    
}

void vis_focos(void){
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("LEDs:",5);
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
    ESCRIBE_MENSAJE("UPC Sem13 2022-2",16);
    while(1){
        unsigned char x;
        switch(estado1){
            case 0:
                for(x=0;x<4;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
            case 1:
                for(x=4;x<6;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
            case 3:
                for(x=8;x<10;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
        }
    }
}

void __interrupt() INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado1 == 3){
        estado1 = 0;
    }
    else{
        estado1++;
    }
}