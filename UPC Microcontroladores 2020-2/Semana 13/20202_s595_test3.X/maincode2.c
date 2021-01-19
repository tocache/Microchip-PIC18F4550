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
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

unsigned char efecto[] = {0x81, 0x42, 0x24, 0x18, 0x24, 0x42}; 

void init_config(void){
    TRISE = 0x00;           //Todo RE como salida
}

void mssp_conf(void){
    SSPCON1bits.SSPEN = 1;
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;
    SSPADD = 119;
}

void pcf8574_write(unsigned char dato){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0x40;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = dato;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);  
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);    
}

void pcf8574b_write(unsigned char dato){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0x42;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = ~dato;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);  
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);    
}

void envio_595(unsigned char datain){
    int i=0;
    LATEbits.LE1 = 0;
    LATEbits.LE0 = 0;
    LATEbits.LE2 = 0;    
    for (i=7; i>=0; i--)    {
        LATEbits.LE1 = 0;
        if (datain &(1<<i))    {
            LATEbits.LE0 = 1;
        }
        else{
            LATEbits.LE0 = 0;
        }
        LATEbits.LE1 = 1;
        LATEbits.LE0 = 0;
    }
    LATEbits.LE2 = 1;
    LATEbits.LE1 = 0;    
}

void main(void){
    init_config();
    mssp_conf();
    while(1){
        for(unsigned char x_var=0;x_var<6;x_var++){
            envio_595(efecto[x_var]);
            pcf8574_write(efecto[x_var]);
            pcf8574b_write(efecto[x_var]);            
            __delay_ms(100);            
        }
    }
}