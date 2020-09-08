/*
 * File:   maincode.c
 * Author: Kalun Lau
 *
 * Created on May 19, 2020, 11:25 AM
 */

//Esta es un comentario
/*Este tambien es un comentario, evitar el uso de tildes y enies en el código*/

// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config USBDIV = 1       // USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 48000000UL   //Para que el XC8 calcule correctamente las instrucciones que tengan que ver con temporizaciones

void configuracion(void){
    //Aquí colocas las configuraciones en los registros SFR
    TRISD = 0xF8;               //Configuración de RD0,RD1 y RD2 como salidas
}

void main(void) {
    configuracion();            //Llamada a la función configuracion
    while(1){
        //bucle infinito
        if (PORTBbits.RB0 == 1){
            //Cuando hay presencia del tren
            LATDbits.LD2 = 0;   //Tranquera abajo
            LATDbits.LD0 = 1;       //Pone a uno lógico el RD0
            LATDbits.LD1 = 0;       //Pone a cero lógico el RD1
            __delay_ms(250);        //Retardo de 250ms
            LATDbits.LD0 = 0;       //Pone a cero lógico el RD0
            LATDbits.LD1 = 1;       //Pone a uyno lógico el RD1
            __delay_ms(250);        //Retardo de 250ms
        }
        else {
            //Cuando no hay presencia del tren
            LATDbits.LD2 = 1;       //Tranquera arriba
            LATDbits.LD0 = 0;       //Pone a cero lógico el RD0
            LATDbits.LD1 = 0;       //Pone a cero lógico el RD1
        }
   }
}
