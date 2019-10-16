//Este es un comentario
//Bits de configuracion o directivas de preprocesador
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
#pragma config LPT1OSC = OFF    // Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo actual

unsigned char estado = 0;

void main(void) {
    INTCONbits.GIE = 1;
    //INTCONbits.PEIE = 1;      //Por verificar si se necesita habilitar por el uso de Int1
    INTCONbits.INT0E = 1;
    INTCON3bits.INT1E = 1;
    ADCON1 = 0x0F;              //Para que todos los puertos ANx sean digitales
    TRISEbits.RE0 = 0;          //Puerto RE0 como salida para manipular el servo
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
    ESCRIBE_MENSAJE("Hola mundo", 10);
    while(1){
        switch(estado){
            case 0:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Servo a 90", 10);
                ENVIA_CHAR(0xDF);
                ESCRIBE_MENSAJE("     ", 15);
                    while(estado == 0){
                        LATEbits.LE0 = 1;
                        __delay_us(1500);
                        LATEbits.LE0 = 0;
                        __delay_us(18500);
                    }
                break;
            case 1:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Servo a 0", 9);
                ENVIA_CHAR(0xDF);
                ESCRIBE_MENSAJE("     ", 16);                
                    while(estado == 1){
                        LATEbits.LE0 = 1;
                        __delay_us(1000);
                        LATEbits.LE0 = 0;
                        __delay_us(19000);
                    }
                break;
            case 2:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Servo a 180", 11);
                ENVIA_CHAR(0xDF);
                ESCRIBE_MENSAJE("     ", 14);                 
                    while(estado == 2){
                        LATEbits.LE0 = 1;
                        __delay_us(2000);
                        LATEbits.LE0 = 0;
                        __delay_us(18000);
                    }
        }
    }
}

void __interrupt (high_priority) Int0_Int1_ISR(void){
    __delay_ms(50);
    if(INTCONbits.INT0F==1){
        estado = 1;
    }
    else if(INTCON3bits.INT1IF==1){
        estado = 2;
    }
    INTCONbits.INT0F = 0;
    INTCON3bits.INT1IF = 0;
}
