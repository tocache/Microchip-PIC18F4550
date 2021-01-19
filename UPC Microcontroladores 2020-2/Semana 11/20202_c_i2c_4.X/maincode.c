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
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

unsigned char button1_stat = 0;
unsigned char button2_stat = 0;
unsigned char frase[] = {"KeepCalm UPC"};  //cadena con 12 caracteres

unsigned char letra = 0;


void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void mssp_conf(void){
    SSPCON1bits.SSPEN = 1;
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;
    SSPADD = 119;
}

void m24c01_escribir(void){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 20;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    for(unsigned char x=0;x<12;x++){
        SSPBUF = frase[x];
        while(SSPSTATbits.BF == 1);
        while(SSPSTATbits.R_nW == 1);
    }
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
}

unsigned char m24c01_leer(unsigned char direccion){
    unsigned char dato_leido = 0;
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = direccion;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.RSEN = 1;
    while(SSPCON2bits.RSEN == 1);
    SSPBUF = 0xA1;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.RCEN = 1;
    while(SSPSTATbits.BF == 0);
    dato_leido = SSPBUF;
    SSPCON2bits.ACKDT = 1;
    SSPCON2bits.ACKEN = 1;
    while(SSPCON2bits.ACKEN == 1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
    return(dato_leido);
}

void main(void){
    lcd_init();
    mssp_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 11 Lab",13);
    while(1){
        if (PORTBbits.RB6 == 1 && button1_stat == 0){
            //Función para grabar la EEPROM
            m24c01_escribir();
            button1_stat = 1;
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Grabando....",12);
        }
        else if(PORTBbits.RB6 == 0 && button1_stat == 1){
            button1_stat = 0;
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Grabado.....",12);
        }
        if (PORTBbits.RB7 == 1 && button2_stat == 0){
            //Función para leer la EEPROM
            POS_CURSOR(2,0);
            for (unsigned char y=0;y<12;y++){
                letra = m24c01_leer(20+y);
                ENVIA_CHAR(letra);
            }
            button2_stat = 1;
        }
        else if(PORTBbits.RB7 == 0 && button2_stat == 1){
            button2_stat = 0;
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("            ",12);
        }
    }
}