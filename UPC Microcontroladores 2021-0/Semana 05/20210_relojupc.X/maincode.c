// PIC18F4550 Configuration Bit Settings
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC4_PLL6// System Clock Postscaler Selection bits ([Primary Oscillator Src: /4][96 MHz PLL Src: /6])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 16000000UL

//Declaracion de variables globales
unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

unsigned char ticks = 0;
unsigned char segundos = 0;
unsigned char minutos = 35;
unsigned char horas = 12;

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void configure(void){
    lcd_init();
    T1CON = 0x31;       //Timer1 Fosc/4, PSC 1:8
    CCP1CON = 0x0B;     //Modo comparador evento especial de disparo
    CCPR1H = 0xC3;      //El valor de comparación es de 50000 (0xC350)
    CCPR1L = 0x50;
    PIE1 = 0x04;        //CCP1IE habilitado
    INTCON = 0xC0;      //PEIE y GIE habilitados
}

void main(void) {
    configure();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("  Reloj UPCINO",14);
    while(1){
        POS_CURSOR(2,3);
        convierte(horas);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(':');
        convierte(minutos);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(':');
        convierte(segundos);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);

    }
}

void __interrupt() CCP1_ISR(void){
    if(ticks == 9){
        ticks = 0;
        if(segundos == 59){
            segundos = 0;
            if(minutos == 59){
                minutos = 0;
                if(horas == 23){
                    horas = 0;
                }
                else{
                    horas++;
                }
            }
            else{
                minutos++;
            }
        }
        else{
            segundos++;
        }
    }
    else{
        ticks++;
    }
    PIR1bits.CCP1IF = 0;
}
