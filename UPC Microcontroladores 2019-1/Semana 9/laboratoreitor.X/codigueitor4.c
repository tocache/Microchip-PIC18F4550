/*
 * File:   codigueitor.c
 * Author: Alumnos
 *
 * Created on 17 de mayo de 2019, 10:15 AM
 */

//Directivas de pre procesador o bits de configutacion
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 4000000UL

char movi = 0;              //Variable indicadora de desplazamientoi 0 a la izquierda por defecto

//void delaymon(int papa){
//    for (int i=0;i<papa;i++){
//        __delay_ms(1);
//    }
//}

void main(void) {
    TRISD = 0x00;          //Declaramos el pin RD0 como salida
    LATD = 0x01;            // Estado inicial del puerto
    while(1){
        if(movi == 1){
            if(LATD == 0x01){
                movi = 0;
            }
            else{
                LATD = LATD >> 1;
//                delaymon(100);
                  __delay_ms(100);
            }
        }
        else{
            if(LATD == 0x80){
                movi = 1;
            }
            else{
                LATD = LATD << 1;
//                delaymon(100);
                  __delay_ms(100);                
            }
        }
    }
}