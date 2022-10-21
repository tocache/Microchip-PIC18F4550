#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char mensaje[] = {"               Termotester UPC               "};
unsigned char x = 0;
unsigned char y = 0;

void configuro(void){
    
}

void arranca_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(23);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    arranca_LCD();
    while(1){
        POS_CURSOR(1,0);
        for(x=0;x<15;x++){
            ENVIA_CHAR(mensaje[x+y]);    
        }
        __delay_ms(100);
        if(y == 30){
            y = 0;
        }
        else{
            y++;            
        }
    }
}
