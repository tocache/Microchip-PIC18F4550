#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

#include <xc.h>
//#include "LCD.h"
#define _XTAL_FREQ 48000000UL

char cadena1[] = {"UPC Monitor"};
char cadena2[] = {"Ingeniera Meca-Elec 2019-1"};
char cadena3[] = {"Salida RB0 = ON"};
char cadena4[] = {"Salida RB0 = OFF"};

//char cadena2[] = {"Lectura de AN-Zero:"};
//char cadena3[] = {"Lectura de AN-Unoo:"};

//-------------------------------------------------------------------------------------
//Rutina para sacar digitos de una variable, para imprimir en el LCD o por puerto serial
int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

void DIGITOS(int valor){
    digdmi = valor / 10000;
    temporal3 = valor - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}
//-------------------------------------------------------------------------------------

void TXCADENA(){
    
}

void main(void) {
    TRISBbits.RB0 = 0;      //Para el LED
    
    //Configuracion del puerto serial del PIC (EUSART))
    TRISCbits.RC6 = 0;      //Ponemos el RC6 como salida
    BAUDCONbits.BRG16 = 0;  //Para trabajar el SPBRG en 8 bits
    TXSTAbits.SYNC = 0;     //Para configurar la velocidad de transmisión a 19200
    TXSTAbits.BRGH = 0;     //Para configurar la velocidad de transmisión
    SPBRG = 38;             //Para configurar la velocidad de trnasmisión
    SPBRGH = 0;             //Para configurar la velocidad de transmisión
    RCSTAbits.SPEN = 1;     //Para habilitar el funcionamiento del EUSART
    RCSTAbits.CREN = 1;
    TXSTAbits.TXEN = 1;     //Habilitamos la tranmisión en el EUSART
//    INTCONbits.GIE = 1;
//    INTCONbits.PEIE = 1;
//    PIE1bits.RC1IE = 1;
    
    while (1)   {
        for (int c=0;c<11;c++)  {       //Imprimir cadena1
            TXREG = cadena1[c];
            while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;                   //Mandar nueva linea
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;                   //Mandar retorno de carro
        while(TXSTAbits.TRMT == 0);
        for (int c=0;c<26;c++)  {       //Imprimir cadena2
            TXREG = cadena2[c];
            while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;                   //Mandar nueva linea
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;                   //Mandar retorno de carro
        while(TXSTAbits.TRMT == 0);
        if (PORTBbits.RB0 == 1){
            for (int c=0;c<15;c++)  {       //Imprimir cadena2
                TXREG = cadena3[c];
                while(TXSTAbits.TRMT == 0);
            }
        }
        else{
            for (int c=0;c<16;c++)  {       //Imprimir cadena2
                TXREG = cadena4[c];
                while(TXSTAbits.TRMT == 0);
            }
        }
        TXREG = 0x0A;                   //Mandar nueva linea
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;                   //Mandar retorno de carro
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0A;                   //Mandar nueva linea
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;                   //Mandar retorno de carro
        while(TXSTAbits.TRMT == 0);
        __delay_ms(500);
        LATBbits.LB0 = !LATBbits.LB0;
    }
}        

//void __interrupt (high_priority) RCIsr(void){
//    PIR1bits.RC1IF = 0;
//    if (RCREG == 0x61){
//        LATDbits.LD0 = 1;
//    }
//    else if (RCREG == 0x62){
//        LATDbits.LD0 = 0;
//    }
//}