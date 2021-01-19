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

unsigned char b_apretado[] = {"boton apretado"};
unsigned char b_napretado[] = {"boton no apretado"};
unsigned char indicador = 0;

void EUSART_config(void){
    SPBRGH = 0;                 //Ignorado debido a que BRG16=0
    SPBRG = 77;
    TRISCbits.RC6 = 0;          //Puerto RC6 como salida, no es necesario
    RCSTAbits.SPEN = 1;         //Encendemos el puerto serial
    TXSTAbits.TXEN = 1;         //Encendemos el transmisor
}

void EUSART_siguientelinea(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);    
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
}

void EUSART_enviacadena(const unsigned char *vector,unsigned char pos){
        for (unsigned char x=0;x<pos;x++){
            TXREG = vector[x];
            while(TXSTAbits.TRMT == 0);    
        }    
}

void main(void) {
    EUSART_config();
    while(1){
        if(PORTBbits.RB6 == 1 && indicador == 0){
            EUSART_enviacadena(b_apretado,14);
            EUSART_siguientelinea();
            indicador = 1;
        }
        else if(PORTBbits.RB6 == 0 && indicador == 1){
            EUSART_enviacadena(b_napretado,17);
            EUSART_siguientelinea();
            indicador = 0;
        }
    }
    return;
}
