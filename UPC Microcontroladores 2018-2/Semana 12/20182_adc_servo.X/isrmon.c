/* Detalle de los bits de configuracion*/
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
#include "LCD.h"
#include "ADC.h"
#define _XTAL_FREQ 48000000UL

//Declaración de variables globales:
int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0, temporal2 = 0, temporal3 = 0;
float pre_cta_on = 0;
float pre_cta_off = 0;
unsigned int cta_on = 0, cta_off = 0;
char cta_msb, cta_lsb;
int resul = 0;

void conviertemon(int contadoron){
    digdmi = resul / 10000;
    temporal3 = resul - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void calculon(int blablabla){
    pre_cta_on = 63428 - (blablabla * 4.712); //63428 y 4.712
    pre_cta_off = 70832 - cta_on;
    cta_on = pre_cta_on;
    cta_off = pre_cta_off;
    digdmi = cta_on / 10000;
    temporal3 = cta_on - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void calculon2(void){
    digdmi = cta_off / 10000;
    temporal3 = cta_off - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void main(void) {
    ADC_CONFIG(0);
    TRISEbits.RE0 = 0;   //Puerto RE0 como salida (para el servo)
    T0CON = 0x81;       //Timer0 en FOsc/4, PSC 1:4, 16bits
    INTCON = 0xA0;      //Interrupción: GIE = 1, TMR0IE = 1
    TRISD = 0x00;       //Para el LCD
    LCD_CONFIG();       //Configuracion inicial para usar el LCD
    __delay_ms(10);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);  //Apagamos el cursor en el LCD
    CURSOR_HOME();      //Movemos el cursor al inicio del LCD (pos 0,0)
    ESCRIBE_MENSAJE("ADC:", 4);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("TON:", 4);
    LATEbits.LE0 = 0;
    while(1){
        resul = ADC_CONVERTIR();
        conviertemon(resul);
        POS_CURSOR(1,5);
        ENVIA_CHAR(digdmi+0x30);
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        calculon(resul);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("I:", 2);
        POS_CURSOR(2,2);
        ENVIA_CHAR(digdmi+0x30);
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        POS_CURSOR(2,8);
        calculon2();
        ESCRIBE_MENSAJE("O:", 2);
        POS_CURSOR(2,10);
        ENVIA_CHAR(digdmi+0x30);
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
    }
}

void __interrupt(high_priority) Tmr0ISR(void){
    if (PORTEbits.RE0 == 1){
        LATEbits.LE0 = 0;
        cta_msb = cta_off >> 8;
        cta_lsb = cta_off & 0x00ff;
        TMR0H = cta_msb;
        TMR0L = cta_lsb;
    }
    else{
        LATEbits.LE0 = 1;
        cta_msb = cta_on >> 8;
        cta_lsb = cta_on & 0x00ff;
        TMR0H = cta_msb;
        TMR0L = cta_lsb;
    }
    INTCONbits.TMR0IF = 0;
}