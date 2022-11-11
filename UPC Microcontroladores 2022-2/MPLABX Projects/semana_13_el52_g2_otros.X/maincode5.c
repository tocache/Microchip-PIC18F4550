#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char visual[]={0x01,0x02,0x04,0x02,0x00,0x07,0x02,0x05,0x06,0x03};
unsigned char estado_v=0;
unsigned char estado_s=0;

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISE = 0xF8;
    INTCON2bits.RBPU = 0;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON3bits.INT1IE = 1;
    INTCON2bits.INTEDG1 = 0;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(22);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void retardo(void){
    switch(estado_s){
        case 0:
            __delay_ms(400);
            break;
        case 1:
            __delay_ms(200);
            break;
        case 2:
            __delay_ms(100);
            break;
    }
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE(" UPC Ing 2022-2",15);
    while(1){
        unsigned char x;
        switch(estado_v){
            case 0:
                LATE = 0x00;
                break;
            case 1:
                for(x=0;x<4;x++){
                    LATE = visual[x];
                    retardo();
                }
                break;
            case 2:
                for(x=4;x<6;x++){
                    LATE = visual[x];
                    retardo();
                }
                break;
            case 3:
                for(x=6;x<8;x++){
                    LATE = visual[x];
                    retardo();
                }
                break;
            case 4:
                for(x=8;x<10;x++){
                    LATE = visual[x];
                    retardo();
                }
                break;
        }
    }
}

void __interrupt() INT0INT1_ISR(void){
    if(INTCONbits.INT0IF == 1){
        INTCONbits.INT0IF = 0;
        if(estado_v == 4){
            estado_v = 0;
        }
        else{
            estado_v++;        
        }
    }
    if(INTCON3bits.INT1IF == 1){
        INTCON3bits.INT1IF = 0;
        if(estado_s == 2){
            estado_s = 0;
        }
        else{
            estado_s++;        
        }
        
    }
}