#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

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

//Hora preconfigurada 12:19:45
int hora = 12;
int minu = 19;
int segu = 45;

void main(void) {
    //Configuracion del LCD
    __delay_ms(500);
    TRISD = 0x00;       //Puerto donde esta conectado el LCD
    LCD_CONFIG();       //Configuracion inicial del LCD
    __delay_ms(15);
    CURSOR_ONOFF(OFF);     //Cursor apagao

    //Configuracion del Timer1 con CCP1 y las interrupciones
    T1CON = 0x83;       //Oscilador 32.768KHz con PSC 1:1
    CCP1CON = 0x0B;     //CCP en comparador evento especial de disparo
    CCPR1H = 0x80;
    CCPR1L = 0x00;      //Valor de comparacion entre CCP1 y Timer1
    INTCONbits.GIE = 1; //Habilitando interruptor global de interrupciones
    INTCONbits.PEIE = 1;//Habilitando interruptor de interrupciones de perifericos
    PIE1bits.CCP1IE = 1;//Habilitando interruptor de interrupciones del CCP1

    CURSOR_HOME();
    ESCRIBE_MENSAJE("UPCTronics 2019",15);
    while(1){
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Hora:",5);
        DIGITOS(hora);
        ENVIA_CHAR(digdec+0x30);    //Impresion de la hora en el LCD
        ENVIA_CHAR(diguni+0x30);
        ENVIA_CHAR(':');
        DIGITOS(minu);        
        ENVIA_CHAR(digdec+0x30);    //Impresion de los minutos en el LCD
        ENVIA_CHAR(diguni+0x30);
        ENVIA_CHAR(':');        
        DIGITOS(segu);        
        ENVIA_CHAR(digdec+0x30);    //Impresion de los segundos en el LCD
        ENVIA_CHAR(diguni+0x30);
    }
    //TRISEbits.RE0 = 0;  //Puerto de salida de prueba
}

void __interrupt(high_priority) CCP1ISR(void){
    if(segu == 59){
        segu = 0;
        if(minu == 59){
            minu = 0;
            if(hora == 23){
                hora = 0;
            }
            else{
                hora++;
            }
        }
        else{
            minu++;
        }
    }
    else{
        segu++;
    }
    //LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.CCP1IF = 0;    //Bajamos la bandera de interrupcion del CCP1
}
