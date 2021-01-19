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
unsigned char frase[] = {"Ingeniero Meca-Elec"};
unsigned char dato = 0; 

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void mssp_config(void){
    SSPCON1bits.SSPEN = 1;      //Encendemos el MSSP
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;      //I2C Master mode
    SSPADD = 119;               //Trabajando a 100KHz    
}

void m24c01_write(void){
    SSPCON2bits.SEN = 1;        //Start
    while (SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;              //Activación de 24C01
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    SSPBUF = 50;                //Dirección donde voy a grabar el dato
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    for (unsigned char x=0;x<14;x++){
        SSPBUF = frase[x];
        while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
        while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    }
    SSPCON2bits.PEN = 1;        //Stop
    while(SSPCON2bits.PEN == 1);
    __delay_ms(15);
    
    SSPCON2bits.SEN = 1;        //Start
    while (SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;              //Activación de 24C01
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    SSPBUF = 64;                //Dirección donde voy a grabar el dato
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    for (unsigned char x=14;x<20;x++){
        SSPBUF = frase[x];
        while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
        while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    }
    SSPCON2bits.PEN = 1;        //Stop
    while(SSPCON2bits.PEN == 1);    
}    

unsigned char m24c01_read(unsigned char direccion){
    unsigned char leido = 0;
    SSPCON2bits.SEN = 1;        //Start
    while (SSPCON2bits.SEN == 1);
    SSPBUF = 0xA0;              //Activación de 24C01
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    SSPBUF = direccion;
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    SSPCON2bits.RSEN = 1;       //Restart
    while(SSPCON2bits.RSEN == 1);
    SSPBUF = 0xA1;              //Activación de 24C01 para leerlo
    while(SSPSTATbits.BF == 1);      //Pregunto si ya se termino de enviar el contenido de SSPBUF
    while(SSPSTATbits.R_nW == 1);    //Pregunto si ya se envió el noveno pulso de reloj
    SSPCON2bits.RCEN = 1;        //modo lectura en el MSSP
    while(SSPSTATbits.BF == 0); //Esperamos a que se termine de recibir!
    leido = SSPBUF;
    SSPCON2bits.ACKDT = 1;      //noACK
    SSPCON2bits.ACKEN = 1;      //iniciamos secuencoa noACK
    while(SSPCON2bits.ACKEN == 1);
    SSPCON2bits.PEN = 1;        //Stop
    while(SSPCON2bits.PEN == 1);
    return(leido);
    //__delay_ms(10);
}

void main(void){
    lcd_init();
    mssp_config();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 11 EEPROM",16);
    while(1){
        if(PORTBbits.RB6 == 1 && button1_stat == 0){
            m24c01_write();
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Writing",7);
            button1_stat = 1;
        }
        if(PORTBbits.RB6 ==0 && button1_stat ==1){
            button1_stat = 0;
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("       ",7);
        }
        if(PORTBbits.RB7 == 1 && button2_stat == 0){
            //Aca leeremos la memoria letra por letra y lo mandamos al LCD
            POS_CURSOR(2,0);
            for(unsigned char y=0;y<20;y++){
                dato = m24c01_read(50+y);
                ENVIA_CHAR(dato);
            }
            button2_stat = 1;
        }
        if(PORTBbits.RB7 ==0 && button2_stat ==1){
            button2_stat = 0;
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("                    ",20);
        }
    }
}