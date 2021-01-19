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
#define _XTAL_FREQ 48000000UL   //Frecuencia del CPU=48MHz

//Declaracion de variables globales
unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
unsigned int lm35raw = 0;       //Aqui se alojara lo medido
unsigned char o_acento[] = {0x02,0x04,0x0E,0x11,0x11,0x11,0x0E,0x00};

//Funcion para inicializar el LCD:
void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

//Funcion para inicializar el A/D:
void adc_init(void){
    ADCON2 = 0xA4;      //ADFM=1 just derecha 8TAD FOSC/4
    ADCON1 = 0x1B;      //Vref+ habilitado, AN3-AN0 en analogico
    ADCON0 = 0x01;      //ADON=1 canal analogico seleccionado AN0
}

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    lcd_init();
    adc_init();
    GENERACARACTER(o_acento,0);
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Term", 4);
    ENVIA_CHAR(0x00);               
    ESCRIBE_MENSAJE("metro", 5);
    while(1){
        ADCON0bits.GODONE = 1;              //Iniciamos la conversion
        while (ADCON0bits.GODONE == 1);     //Esperamos a que termine de convertir
        lm35raw = (ADRESH << 8) + ADRESL;   //Obtenemos el resultado
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T0:", 3);
        lm35raw = lm35raw / 10;             //Escalando de cuentas a grados centigrados
        convierte(lm35raw);
//        ENVIA_CHAR(d_millar+0x30);        //Escribo el numero d_millar en caracter ASCII
//        ENVIA_CHAR(millar+0x30);        //Escribo el numero millar en caracter ASCII
        ENVIA_CHAR(centena+0x30);       //Escribo el numero centena en caracter ASCII
        ENVIA_CHAR(decena+0x30);        //Escribo el numero decena en caracter ASCII
        ENVIA_CHAR(unidad+0x30);        //Escribo el numero unidad en caracter ASCII 
        ENVIA_CHAR(0xDF);               //Escribo el simbolo de grado 
        ESCRIBE_MENSAJE("C", 1);
    }
}