#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

unsigned char x_temp=0;

void CPU_Init(void){
    INTCONbits.INT0E = 1;
    INTCONbits.GIE = 1;
    INTCON2bits.INTEDG0 = 1;        //selector de flanco en INT0
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
    ESCRIBE_MENSAJE_2("Detectando INT0");
    while(1){
        if(x_temp == 1){
            __delay_ms(3000);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE_2("                ");
            x_temp = 0;
        }
    }
}

void __interrupt() INT0_ISR(void){
    if(INTCON2bits.INTEDG0 == 1){
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE_2("Presionaste INT0");
        INTCONbits.INT0IF = 0;
        x_temp = 1;
        INTCON2bits.INTEDG0 = 0;        //selector de flanco en INT0
    }
    else{
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE_2("Soltaste INT0   ");
        INTCONbits.INT0IF = 0;
        x_temp = 1;
        INTCON2bits.INTEDG0 = 1;        //selector de flanco en INT0
    }
}