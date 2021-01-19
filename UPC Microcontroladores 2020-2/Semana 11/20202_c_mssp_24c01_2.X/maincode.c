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

unsigned char dato = 0;

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

//Funcion para configurar el modulo MSSP
void mssp_conf(){
    SSPCON1bits.SSPEN = 1;   //Habilitamos el MSSP
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;  //I2C Master mode
    SSPADD = 29;
}

void m24c01_write(void){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;                  //Habilitamos el uso del 24C01
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 100;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'I';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'n';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'g';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'e';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'n';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'i';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'e';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'r';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'i';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = 'a';
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
    __delay_ms(10);
}

unsigned char m24c01_read(unsigned char direccion){
    unsigned char leido = 0;
    SSPCON2bits.SEN = 1;        //Start
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;              //Palabra de control
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = direccion;               //Direccion a acceder en la 24c01
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.RSEN = 1;
    while(SSPCON2bits.RSEN == 1);
    SSPBUF = 0xA1;              //Cambiamos a modo lectura
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.RCEN = 1;
    while(SSPCON2bits.RCEN == 1);
    while(SSPSTATbits.BF == 0); //Esperamos a que se llene el registro de recepcion
    leido = SSPBUF;
    SSPCON2bits.ACKDT = 1;
    SSPCON2bits.ACKEN = 1;
    while(SSPCON2bits.ACKEN == 1);  //Proceso del noACK
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
    return(leido);
}

void main(void){
    lcd_init();
    mssp_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Grabador de EEPROM",18);
    while(1){
        if(PORTBbits.RB6 == 1){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Writing...",10);
            m24c01_write();
        }
        else if(PORTBbits.RB7 == 1){
            POS_CURSOR(2,0);
            for(unsigned char x=0;x<10;x++){
                dato = m24c01_read(x+100);
                ENVIA_CHAR(dato);
            }
        }
        else{
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Ready...  ",10);
        }

    }
}