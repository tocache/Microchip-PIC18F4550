/*Este es un comentario en XC8*/
//Este tambien es un comentario

//Declaramos los bits de configuracion (directivas de preprocesador)
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>                 //Declaración de librería XC

#define _XTAL_FREQ 4000000UL     //Velocidad del oscilador principal

char var_a = 0;

void main(void) {
    /*Aquí va el código de usuario*/
    TRISDbits.RD0 = 0;          //Puerto D0 como salida
    TRISDbits.RD1 = 0;          //Puerto D1 como salida
    while(1){
        for (var_a=0;var_a<4;var_a++) {
            LATDbits.LD0 = 1;
            __delay_ms(100);
            LATDbits.LD0 = 0;
            __delay_ms(100);
        }
        for (var_a=0;var_a<4;var_a++) {
            LATDbits.LD1 = 1;
            __delay_ms(100);
            LATDbits.LD1 = 0;
            __delay_ms(100);
        }

    }
}
