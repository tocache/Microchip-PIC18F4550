#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = OFF      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

unsigned char dato = 0xAA;

void init_config(void){
    SSPCON1bits.SSPEN = 1;      //Encendemos el MSSP
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;      //MSSP en I2C master
    SSPADD = 119;               // clock en 100khz
}

void pcf8574_escribir(unsigned char dato){
    SSPCON2bits.SEN = 1;        //evento de inicio
    while(SSPCON2bits.SEN == 1);    //espero a que se termine el evento (ACK)
    SSPBUF = 0x40;
    while(SSPSTATbits.BF ==1);  //espero a que se termine de enviar la palabra de control
    while(SSPSTATbits.R_nW ==1);
    SSPBUF = dato;
    while(SSPSTATbits.BF ==1);  //espero a que se termine de enviar la palabra de control
    while(SSPSTATbits.R_nW ==1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
}

void main(void){
    init_config();
    while(1){
        pcf8574_escribir(0x55);
        __delay_ms(100);
        pcf8574_escribir(0xAA);
        __delay_ms(100);
    }
}
