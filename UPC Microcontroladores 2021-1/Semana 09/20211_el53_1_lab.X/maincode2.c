//Zona de bits de configuracion
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

//Zona de claracion de variables globales
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void init_conf(void){
    //Aca colocaremos las configuraciones iniciales de la aplicacion
    //TRISDbits.RD0 = 0;          // RC0 como salida
    asm("bcf TRISC, 0");          // Escribiendo instrucciones en mpasm
    asm("bcf TRISC, 2");          // Escribiendo instrucciones en mpasm    
    ADCON2 = 0x24;                 //ADFM = 0
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned char numero){
    centena = numero / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    init_conf();
    lcd_init();
    POS_CURSOR(1,2);
    ESCRIBE_MENSAJE("Lectura ADC:", 11);
    LATCbits.LC2 = 1;           //Backlight del LCD encendido
    while(1){
        ADCON0bits.GODONE = 1;      //Lectura de AN0
        while(ADCON0bits.GODONE == 1);
        convierte(ADRESH);
        POS_CURSOR(2,2);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}
