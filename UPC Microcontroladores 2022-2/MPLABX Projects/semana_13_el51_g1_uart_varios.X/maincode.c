#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

unsigned char efecto[] = {0x01, 0x02, 0x04, 0x02};

void configuro(void){
    OSCCON = 0x70;  //Reloj a 8MHz
    ADCON1 = 0x0F;  //Todos los ANx como digitales
    TRISE = 0xF8;   //RE0:RE2 como salidas
}

void main(void) {
    configuro();
    while(1){
        unsigned char x;
        for(x=0;x<4;x++){
            LATE = efecto[x];
            __delay_ms(200);
        }
    }
}
