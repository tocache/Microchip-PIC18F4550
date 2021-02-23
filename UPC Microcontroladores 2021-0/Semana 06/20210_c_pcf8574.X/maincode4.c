#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = OFF      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

                         //		A     B     C     D     E     F     G     H     I     J     K     L     M     N     O     P     Q     R     S     T     U     V     W     X     Y     Z         
unsigned char romcharacter[] = {0x5F, 0x7C, 0x58, 0x5E, 0x79, 0x71, 0x3D, 0x74, 0x11, 0x0D, 0x75, 0x38, 0x55, 0x54, 0x5C, 0x73, 0x67, 0x50, 0x6D, 0x78, 0x1C, 0x2A, 0x6A, 0x14, 0x6E, 0x1B};

unsigned char msg[] = {"        MI NOMBRE ES KALUN JOSE LAU GAN Y SOY UPCINO       "};
unsigned char temporal = 0;

void init_config(void){
    SSPCON1bits.SSPEN = 1;      //Encendemos el MSSP
    SSPCON1bits.SSPM3 = 1;
    SSPCON1bits.SSPM2 = 0;
    SSPCON1bits.SSPM1 = 0;
    SSPCON1bits.SSPM0 = 0;      //MSSP en I2C master
    SSPADD = 119;               // clock en 100khz
}

void pcf8574_escribir(unsigned char dato, unsigned char disp){
    SSPCON2bits.SEN = 1;        //evento de inicio
    while(SSPCON2bits.SEN == 1);    //espero a que se termine el evento (ACK)
    SSPBUF = (0x40 + (disp*2));
    while(SSPSTATbits.BF ==1);  //espero a que se termine de enviar la palabra de control
    while(SSPSTATbits.R_nW ==1);
    SSPBUF = dato;
    while(SSPSTATbits.BF ==1);  //espero a que se termine de enviar la palabra de control
    while(SSPSTATbits.R_nW ==1);
    SSPCON2bits.PEN = 1;
    while(SSPCON2bits.PEN == 1);
}

void main(void){
    init_config();
    while(1){
        for (unsigned char i=0;i<64;i++){                   //para el desplazamiento del mensaje
            for (unsigned char disp=0;disp<8;disp++){       //para colocar datos en los ocho displays
                if (msg[i+disp] == 0x20){
                    pcf8574_escribir(0x00, disp); //cuando es un espacio el caracter
                }
                else{
                    pcf8574_escribir(romcharacter[(msg[i+disp]-0x41)], disp);  //cuando el caracter es A-Z
                }
            }
            __delay_ms(150);
        }
    }
}
