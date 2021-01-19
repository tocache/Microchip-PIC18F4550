// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements

//Bits de configuracion
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
/*El microcontrolador tiene funcionando el PLL con 48MHz al CPU*/

//Zona de declaracion de variables globales
unsigned int lm35var = 0;
unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
unsigned char o_tilde[] = {0x02,0x04,0x00,0x0E,0x11,0x11,0x11,0x0E};
unsigned char cara_feliz[] = {	0b00000000,
                            0b00001010,
                            0b00001010,
                            0b00001010,
                            0b00000000,
                            0b00010001,
                            0b00001110,
                            0b00000000};

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void adc_init(void){
    ADCON2 = 0xA4;                      //ADFM=1, 8TAD, Fosc/4
    ADCON1 = 0x1B;                      //Vref+ habilitado, AN3-AN0 como analógicos
    ADCON0 = 0x01;                      //ADON=1, AN0 seleccionado
}

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    lcd_init();
    adc_init();
    GENERACARACTER(o_tilde, 0);
    GENERACARACTER(cara_feliz, 1);
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Term", 4);
    ENVIA_CHAR(0x00);
    ESCRIBE_MENSAJE("metro LS5A: ", 12);
    ENVIA_CHAR(0x01);
    while(1){
        ADCON0bits.GODONE = 1;          //Obtenemos una muestra de AN0
        while(ADCON0bits.GODONE == 1);
        lm35var = (ADRESH <<8) + ADRESL;
        lm35var = lm35var /10;
        convierte(lm35var);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("LM35: ", 6);
        //ENVIA_CHAR(d_millar+0x30);
        //ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(0x2E);
        ENVIA_CHAR(0x30);
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C", 1);        
    }
}    