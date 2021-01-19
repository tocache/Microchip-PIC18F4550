// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
// CONFIG1L

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

//Funcion para inicializar el LCD:
void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void tmr2_config(){
    T2CON = 0x45;
    //PR2 = 170;
}

void int_config(){
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR2IE = 1;
}

void ad_config(){
    ADCON2 = 0x24;
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void main(void){
    lcd_init();
    tmr2_config();
    int_config();
    ad_config();
    //ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("   Generator   ", 15);
    while(1){
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        PR2 = ADRESH;
        convierte(ADRESH);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("PR2:", 4);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt(high_priority) TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}