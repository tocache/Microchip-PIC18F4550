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

unsigned char mensaje1[] = {"Boton presionado"};
unsigned char mensaje2[] = {"Boton soltado   "};
unsigned char indicador = 0;

void init_conf(void){
    TRISCbits.RC6 = 0;              //Salida para TXD del EUSART
}

void EUSART_conf(){
    SPBRG = 77;                     //Vtx = 9600
    RCSTAbits.SPEN = 1;         //Habilitamos el puerto serial
    TXSTAbits.TXEN = 1;         //Habilitamos la transmision
}

void main(void){
    init_conf();
    EUSART_conf();
    while(1){
        if(PORTBbits.RB6 == 1 && indicador == 0){
            for (unsigned char x=0;x<16;x++){
                TXREG = mensaje1[x];
                while(TXSTAbits.TRMT == 0); //Esperar a que se termine de transmitir
            }
            TXREG = 0x0A;       //Comando para nueva linea
            while(TXSTAbits.TRMT == 0); //Esperar a que se termine de transmitir
            TXREG = 0x0D;       //Comando para retorno de carro
            while(TXSTAbits.TRMT == 0); //Esperar a que se termine de transmitir
            indicador = 1;
        }
        else if(PORTBbits.RB6 == 0 && indicador == 1){
            for (unsigned char x=0;x<16;x++){
                TXREG = mensaje2[x];
                while(TXSTAbits.TRMT == 0); //Esperar a que se termine de transmitir
            }
            TXREG = 0x0A;       //Comando para nueva linea
            while(TXSTAbits.TRMT == 0); //Esperar a que se termine de transmitir
            TXREG = 0x0D;       //Comando para retorno de carro
            while(TXSTAbits.TRMT == 0); //Esperar a que se termine de transmitir
            indicador = 0;
        }
    }
}