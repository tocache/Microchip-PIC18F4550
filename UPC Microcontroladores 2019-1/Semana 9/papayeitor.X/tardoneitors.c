/*
 * File:   tardoneitors.c
 * Author: Masta Naluk
 *
 * Created on 16 de mayo de 2019, 10:14 AM
 */
//Este es un comentario
/*Este es otro comentario*/

/*Directivas de preprocesador o bits de configuracion*/
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>                 //Libreria del XC
#define _XTAL_FREQ 4000000UL    //Especificacion de la velocidad del oscilador principal

void main(void) {
    TRISDbits.RD0 = 0;
    while(1){
    LATDbits.LD0 = 1;
    __delay_ms(200);
    LATDbits.LD0 = 0;
    __delay_ms(200);
    }
}
