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

unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void convierte(unsigned int numero){
    millar = numero /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void ad_config(void){
    ADCON2 = 0x24;                  //8TAD, Fosc/4, ADFM=0
    ADCON1 = 0x0E;                  //AN0 sea analógico
    ADCON0 = 0x01;                  //Habilitamos el A/D
}

void tmr2_config(void){
    T2CON = 0x45;                   //PRE 1:4 POST 1:8 TMR2ON
    //PR2 = 170;                      //Valor de referencia de la comparacion
}

void int_config(void){
    RCONbits.IPEN = 1;              //prioridades habilitadas
    INTCONbits.GIEH = 1;             //interruptor global habilitado high
    INTCONbits.GIEL = 1;            //interruptor global low priority
    PIE1bits.TMR2IE = 1;            //interrupcion por tmr2 habilitado
    INTCON3bits.INT1IE = 1;         //interrupcion int1 habilitado
    INTCON3bits.INT1IP = 0;         //int1 en baja prioridad
}

void main(void) {
    lcd_init();                     //Llamamos a la funcion
    tmr2_config();                  //Llamamos a la funcion
    int_config();                   //llamamos a la funcion
    ad_config();                    //Llamamos a la funcion
    //ADCON1 = 0x0F;                  //RE como digitales
    TRISEbits.RE0 = 0;              //RE0 como salida
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Hola mundo!",11);
    while(1){
        ADCON0bits.GODONE = 1;      //Iniciamos la conversión de una muestra
        while(ADCON0bits.GODONE == 1);
        PR2 = ADRESH;
        convierte(ADRESH);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("PR2:",4);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt(high_priority) TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}

void __interrupt(low_priority) INT1_ISR(void){
    T2CONbits.TMR2ON = !T2CONbits.TMR2ON;       //basculamos el funcionamiento de TMR2
    INTCON3bits.INT1IF = 0;                     //bajamos la bandera INT1IF
}