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
#define _XTAL_FREQ 48000000UL

//Declaración de variables globales:
int contador = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
unsigned int cta_on = 0;
unsigned int cta_off = 0;

void conviertemon(int contadoron){
        digcen = contadoron / 100;
        temporal = contadoron - (digcen * 100);
        digdec = temporal / 10;
        diguni = temporal - (digdec * 10);
}

void main(void) {
    ADCON1 = 0x0F;      //Puertos RA y RD como digitales
    TRISEbits.RE0 = 0;   //Puerto RE0 como salida (para el servo)
    T0CON = 0x81;       //Timer0 en FOsc/4, PSC 1:4, 16bits
    INTCON = 0xA0;      //Interrupción: GIE = 1, TMR0IE = 1
    TRISD = 0x00;       //Para el LCD
    LCD_CONFIG();       //Configuracion inicial para usar el LCD
    __delay_ms(10);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);  //Apagamos el cursor en el LCD
    CURSOR_HOME();      //Movemos el cursor al inicio del LCD (pos 0,0)
    ESCRIBE_MENSAJE("Cuenta:", 7);
    while(1){
        conviertemon(contador);
        POS_CURSOR(1,8);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        __delay_ms(10);
        if (contador >= 299){
            contador = 0;
        }
        else{
            contador++;
            if (contador < 100){
                cta_on = 58633;
                cta_off = 12414;
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Servo Izquierda", 15);                
            }
            else if (contador >= 100 && contador < 200){
                cta_on = 61034;
                cta_off = 10013;
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Servo Centro    ", 15);                
            }
            else{
                cta_on = 63435;
                cta_off = 7612;
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Servo Derecha  ", 15);                
            }    
        }
    }
}
//posible bug!!!
void __interrupt(high_priority) Tmr0ISR(void){
    if (PORTEbits.RE0 == 1){
        LATEbits.LE0 = 0;
        TMR0 = cta_on;
    }
    else{
        LATEbits.LE0 = 1;
        TMR0 = cta_off;
    }
    INTCONbits.TMR0IF = 0;
}
