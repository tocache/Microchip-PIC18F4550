
//Zona de bits de configuracion
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
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
#define _XTAL_FREQ 48000000UL

void init_conf(void){
    //Aca colocaremos las configuraciones iniciales de la aplicacion
    TRISD = 0x00;   //RD como salida
    ADCON2 = 0x24;  //8TAD, FOSC/4 ADFM=0
    ADCON1 = 0x0E;  //AN0 habilitado
    ADCON0 = 0x01;  //AN0 seleccionado y AD funcionando
}

void main(void) {
    //Aca va la rutina principal
    init_conf();
    while(1){
        ADCON0bits.GODONE = 1;  //Inicio la conversion en AN0
        while(ADCON0bits.GODONE == 1);
        LATD = ADRESH;
    }
}