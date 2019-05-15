//Programa hecho por master Kalun
// /---\    /---------\
// |^_^| --/Somos      |
// \---/   |   Micro   |
//   |  Y  |     2019-1|
// /---/    \---------/
// | |
//   |
//   ^
//  / \
// -   -

#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

/*Definimos la velocidad del oscilador principal*/
#define _XTAL_FREQ 4000000UL

/*Llamado a la librería XC*/
#include <xc.h>

void main(void) {
    /*Declaramos primero el puerto de salida D0*/
    //Este es otro comentario
    TRISD = 0xFC;               /*Salidas RD0 y RD1*/
    while(1){
        for (char i=0;i<3;i++){
            LATD = 0x01;
            __delay_ms(100);
            LATD = 0x00;
            __delay_ms(100);
        }
        for (char i=0;i<3;i++){
            LATD = 0x02;
            __delay_ms(100);
            LATD = 0x00;
            __delay_ms(100);
        }
    }
}
