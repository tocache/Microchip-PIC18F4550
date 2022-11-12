#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo 48MHz

void configuracion(void){

}

void lcd_init(void){
    TRISD = 0X00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuracion();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Hola UPCino!", 12);
    while(1){
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("*                ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE(" *               ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("  *              ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("   *             ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("    *            ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("     *           ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("      *          ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("       *         ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("        *        ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("         *       ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("          *      ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("           *     ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("            *    ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("             *   ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("              *  ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("               * ",16);
        __delay_ms(100);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("                *",16);
        __delay_ms(100);
    }
}
