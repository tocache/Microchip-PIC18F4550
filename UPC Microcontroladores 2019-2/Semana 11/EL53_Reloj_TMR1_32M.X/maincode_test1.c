//Este es un comentario
//Bits de configuracion o directivas de preprocesador
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
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

#define _XTAL_FREQ 32000000UL   //Frecuencia de trabajo actual
#include <xc.h>
#include "LCD.h"

unsigned char ticks = 0;        //Para contar la cantidad de veces de CCP1IF=1
unsigned char segundos = 0;     //Variable para los segundos
unsigned char minutos = 0;      //Variable para los minutos
unsigned char horas = 0;        //Variable para las horas
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void arrancaLCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
}

void convierte(unsigned char numero){
    centena = numero / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    T1CON   = 0xB1;             //FOSC/4 PSC1:8
    CCP1CON = 0x0B;
    CCPR1L = 0x50;              //Valor de comparacion del CCP1 = 50000 (0xC350)
    CCPR1H = 0xC3; 
    //ADCON1 = 0x0F;              //Puerto RE como digitales  
    //TRISEbits.RE0 = 0;          //LED de prueba para ver si funciona el sistema RTC
    INTCONbits.GIE = 1;         //Habilitado el interruptor global de interrupciones
    INTCONbits.PEIE = 1;        //Habilitado la interrupcion de perifericos
    PIE1bits.CCP1IE = 1;        //Habilitado la interrupcion por CCP1
    arrancaLCD();               //Inicializacion del LCD
    ESCRIBE_MENSAJE("Reloj UPC 2019-2",16);
    while(1){
        POS_CURSOR(2, 0);
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
        while(PORTBbits.RB0 == 1 && PORTBbits.RB1 == 0){    //Seteo de horas con RB0
            horas = horas + 1;
            __delay_ms(300);
        }
        while(PORTBbits.RB0 == 0 && PORTBbits.RB1 == 1){    //Seteo de minutos con RB1
            minutos = minutos + 1;
            __delay_ms(300);        
        }
    }
}

void __interrupt() CCP1ISR(void){
    if(ticks == 19){
        ticks = 0;
        //LATEbits.LE0 = !LATEbits.LE0;     Prueba para ver si funciona el RTC
        if(segundos == 59){
            segundos = 0;
            if(minutos == 59){
                minutos = 0;
                if(horas == 23){
                    horas = 0;
                }
                else{
                    horas = horas + 1;
                }
            }
            else{
                minutos = minutos + 1;
            }
        }
        else{
            segundos = segundos + 1;
        }
    }
    else{
        ticks = ticks + 1;
    }
    PIR1bits.CCP1IF = 0;
}
