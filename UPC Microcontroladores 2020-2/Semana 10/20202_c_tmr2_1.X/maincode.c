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
#define _XTAL_FREQ 48000000UL   //Frecuencia del CPU=48MHz

unsigned int var_gen = 0;

unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void convierte(unsigned int numero){
    millar = numero /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void tmr2_conf(void){
    T2CON = 0x45;
    PR2 = 164;
}

void int_conf(void){
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR2IE = 1;
}

void ad_conf(){
    ADCON2 = 0x24;               //ADFM=0 (just izquierda), 8TAD, Fosc/4
    ADCON1 = 0x0E;              //Canal AN0 habilitado
    ADCON0 = 0x01;              //Canal AN0 seleccionado y encendemos el A/D
}

void main(void){
    lcd_init();
    tmr2_conf();
    ad_conf();
    int_conf();
    //ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Generador",9);
    while(1){
        ADCON0bits.GODONE = 1;           //Inicio una captura de mueestra en AN0
        while(ADCON0bits.GODONE == 1);   //Espero a que termine de convertir
        PR2 = ADRESH;
        var_gen = ADRESH;
        convierte(var_gen);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Valor de PR2:",13);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(+0x30);
        
    };
}

void __interrupt(high_priority) High_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}

