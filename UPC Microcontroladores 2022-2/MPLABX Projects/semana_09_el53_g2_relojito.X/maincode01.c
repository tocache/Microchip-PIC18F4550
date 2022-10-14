//este es un comentario
/*es tambien es un comentario*/
#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISBbits.RB0 = 0;
}

void main(void) {
    configuro();
    while(1){
        LATBbits.LB0 = 1;
        __delay_ms(100);
        LATBbits.LB0 = 0;
        __delay_ms(100);
    }
}
