#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

unsigned char x_temp=0;

void CPU_Init(void){
    INTCONbits.RBIE = 1;
    INTCONbits.GIE = 1;
}

void LCD_Init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}    

void main(void) {
    CPU_Init();
    LCD_Init();
    ESCRIBE_MENSAJE_2("Detectando....");
    while(1){
        if(x_temp == 1){
            __delay_ms(3000);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE_2("                ");
            x_temp = 0;
        }
    }
}

void __interrupt() RB_ISR(void){
    unsigned char cualquiera=0;
    if(PORTBbits.RB7 == 1){
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE_2("RB7=1");
    }
    else{
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE_2("RB7=0");
    }
    if(PORTBbits.RB4 == 1){
        POS_CURSOR(2,6);
        ESCRIBE_MENSAJE_2("RB4=1");
    }
    else{
        POS_CURSOR(2,6);
        ESCRIBE_MENSAJE_2("RB4=0");
    }
    cualquiera = PORTB;
    __delay_us(1);
    INTCONbits.RBIF = 0;
    x_temp = 1;
}