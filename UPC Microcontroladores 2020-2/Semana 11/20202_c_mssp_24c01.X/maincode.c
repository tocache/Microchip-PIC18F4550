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

unsigned char datoin = 0;
unsigned char nombre[] = {"Ingenieria"};

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void mssp_conf(){
    SSPCON1bits.SSPEN = 1;      //Habilitamos el MSSP
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;
    SSPADD = 29;
}

unsigned char i2c_read(unsigned char direccion){
    //--------------
    //Proceso de lectura de la EEPROM
    unsigned char leido = 0;
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;                 //Palabra de control
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = direccion;                  //Enviamos dirección de acceso
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);    
    SSPCON2bits.RSEN = 1;            //Le tengo que hacer un restart
    while(SSPCON2bits.RSEN == 1);
    SSPBUF = 0xA1;                 // Palabra de control a modo lectura
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.RCEN = 1;            //Ahora el MSSP pasa a modo lectura
    while(SSPSTATbits.BF == 0);     //Esperamos a que se llene el registro de recepcion
    leido = SSPBUF;                 //Pasamos lo recibido a la variable leido
    SSPCON2bits.ACKDT = 1;          //Enviando el noACK
    SSPCON2bits.ACKEN = 1;          //Enviando el noACK
    while(SSPCON2bits.ACKEN == 1);  //Esperamos a que se termine de enviar el noACK
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
    return(leido);
}

void i2c_write(unsigned char direccion1, unsigned char dato1){
    SSPCON2bits.SEN = 1;
    while(SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;                 //Palabra de control
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = direccion1;                  //Enviamos dirección de acceso
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPBUF = dato1;
    while(SSPSTATbits.BF == 1);
    while(SSPSTATbits.R_nW == 1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
    __delay_ms(10);
}

void main(void){
    lcd_init();
    mssp_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Grabando EEPROM",15);
    for(unsigned char x=0; x<10; x++){
        i2c_write(x+100, nombre[x]);
    }

    POS_CURSOR(2,0);
    for(unsigned char x=0;x<10;x++){
        datoin = i2c_read(x+100);
        ENVIA_CHAR(datoin);
    }
    while(1){
    }
}