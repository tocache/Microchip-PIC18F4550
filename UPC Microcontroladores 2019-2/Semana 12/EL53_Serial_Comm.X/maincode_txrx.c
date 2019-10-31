#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

#include <xc.h>
#define _XTAL_FREQ 32000000UL

char cadena[] = {"Machuca A para prender LED, B para apagarlo"};
char ledon[] = {"LED ENCENDIDO PE"};
char ledoff[] = {"LED APAGAO"};
char errorpe[] = {"TECLA ERRONEA PE ON"};


void main(void) {
    TRISDbits.RD0 = 0;      //Para el LED
    TRISCbits.RC6 = 0;      //Ponemos el RC6 como salida
    BAUDCONbits.BRG16 = 0;  //Para trabajar el SPBRG en 8 bits
    TXSTAbits.SYNC = 0;     //Para configurar la velocidad de transmisión
    TXSTAbits.BRGH = 0;     //Para configurar la velocidad de transmisión
    SPBRG = 51;             //Para configurar la velocidad de trnasmisión
    SPBRGH = 0;             //Para configurar la velocidad de transmisión
    RCSTAbits.SPEN = 1;     //Para habilitar el funcionamiento del EUSART
    RCSTAbits.CREN = 1;
    TXSTAbits.TXEN = 1;     //Habilitamos la tranmisión en el EUSART
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.RC1IE = 1;
    
    while (1)   {
        for (int c=0;c<43;c++)  {
            TXREG = cadena[c];
            while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);
        __delay_ms(500);
    }
}        

void __interrupt (high_priority) RCIsr(void){
    PIR1bits.RC1IF = 0;
    if (RCREG == 0x61){
        LATDbits.LD0 = 1;
        for (int c=0;c<16;c++)  {
            TXREG = ledon[c];
        while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);
    }
    else if (RCREG == 0x62){
        LATDbits.LD0 = 0;
        for (int c=0;c<10;c++)  {
            TXREG = ledoff[c];
        while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);
    }
    else{
        for (int c=0;c<19;c++)  {
            TXREG = errorpe[c];
        while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);
    }
}