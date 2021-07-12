#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

#define _XTAL_FREQ 48000000UL

unsigned char reloj0[]={0x1F,0x1F,0x0E,0x04,0x0A,0x11,0x1F,0x00};
unsigned char reloj1[]={0x1F,0x1B,0x0E,0x04,0x0A,0x15,0x1F,0x00};
unsigned char reloj2[]={0x1F,0x11,0x0E,0x04,0x0A,0x1F,0x1F,0x00};
unsigned char reloj3[]={0x1F,0x11,0x0A,0x04,0x0E,0x1F,0x1F,0x00};
unsigned char reloj4[]={0x0A,0x12,0x03,0x1F,0x07,0x07,0x06,0x00};
unsigned char reloj5[]={0x00,0x11,0x1B,0x07,0x1B,0x11,0x00,0x00};
unsigned char reloj6[]={0x0E,0x0F,0x1F,0x07,0x04,0x14,0x0C,0x00};
unsigned char reloj7[]={0x1F,0x1F,0x0E,0x04,0x0A,0x11,0x1F,0x00};

void LCD_Init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(reloj0, 0);
    GENERACARACTER(reloj1, 1);
    GENERACARACTER(reloj2, 2);
    GENERACARACTER(reloj3, 3);
    GENERACARACTER(reloj4, 4);
    GENERACARACTER(reloj5, 5);    
    GENERACARACTER(reloj6, 6);    
    GENERACARACTER(reloj7, 7);
}

void main(void) {
    LCD_Init();
    ESCRIBE_MENSAJE("Cargando sistema",16);
    unsigned char y=0;
    unsigned char x=0;
    for(y=0;y<5;y++){
        for(x=0;x<8;x++){
            POS_CURSOR(2,0);
            ENVIA_CHAR(x);
            __delay_ms(200);
        }
    }
    while(1);
}
