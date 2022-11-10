#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char efecto[]={0x05,0x02,0x00,0x07,0x06,0x03};
unsigned char estado_e=0;
unsigned char estado_t=0;
unsigned char foco_off[]={0x0E,0x11,0x11,0x11,0x11,0x0A,0x0E,0x0E};
unsigned char foco_on[]={0x0E,0x1F,0x1F,0x1F,0x1F,0x0E,0x0E,0x0E};

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISE = 0xF8;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
    INTCON3bits.INT1IE = 1;
    INTCON2bits.INTEDG1 = 0;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(foco_off,0);
    GENERACARACTER(foco_on,1);
}

void LCD_LEDs(void){
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
    
void retardon(void){
    switch(estado_t){
        case 0:
            __delay_ms(100);
            break;
        case 1:
            __delay_ms(200);
            break;
        case 2:
            __delay_ms(400);
            break;
    }
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Micro S13 2022-2",16);
    while(1){
        unsigned char x;
        switch(estado_e){
            case 0:
                for(x=0;x<2;x++){
                    LATE = efecto[x];
                    LCD_LEDs();
                    retardon();
                }
                break;
            case 1:
                for(x=2;x<4;x++){
                    LATE = efecto[x];
                    LCD_LEDs();
                    retardon();
                }
                break;
            case 2:
                for(x=4;x<6;x++){
                    LATE = efecto[x];
                    LCD_LEDs();
                    retardon();
                }
                break;
        }
    }
}

void __interrupt() INT0_ISR(void){
    if(INTCONbits.INT0IF == 1){
        INTCONbits.INT0IF = 0;
        if(estado_e == 2){
            estado_e = 0;
        }
        else{
            estado_e++;
        }
    }
    if(INTCON3bits.INT1IF == 1){
        INTCON3bits.INT1IF = 0;
        if(estado_t == 2){
            estado_t = 0;
        }
        else{
            estado_t++;
        }
    }
}
