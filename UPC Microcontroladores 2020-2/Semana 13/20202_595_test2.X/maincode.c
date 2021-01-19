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

unsigned char dato_595 = 0;
unsigned char auto_fantastico[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02};

void init_config(void){
    //configuracion inicial
    TRISE = 0x00;                   //RE como salidas
    ADCON1 = 0x0F;                  //RE como digitales
    TRISD = 0x00;
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

void c595_dataout(unsigned char datain){
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
        for(unsigned char y_var=0;y_var<14;y_var++){
            c595_dataout(auto_fantastico[y_var]);
            pcf8574_write(auto_fantastico[y_var]);
            LATD = auto_fantastico[y_var];
            __delay_ms(100);
        }
    }
}