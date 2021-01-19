// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
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
#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo 48MHz

unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    millar = numero /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void ad_conf(){
    ADCON2 = 0x24;      //8TAD, Fosc/4, ADFM=0 just izq.
    ADCON1 = 0x0E;      //AN0 habilitado
    ADCON0 = 0x01;      //Habilitamos el A/D
}

void tmr2_conf(){
    T2CON = 0x45;   //PRESC1:4, POSSC1:8, TMR2=ON
//    PR2 = 188;      //Valor de referencia al comparador del TMR2
}

void port_conf(){
    ADCON1 = 0x0F;          //Puertos en digital
    TRISEbits.RE0 = 0;      //RE0 como salida
}

void int_conf(){
    INTCONbits.GIE = 1;         //Habilito interruptor global de interrupciones
    INTCONbits.PEIE = 1;        //Habilito interruptor de interrupcion de perifericos
    PIE1bits.TMR2IE = 1;        //Habilito interrupcion de TMR2
}

void main(void){
    lcd_init();
    ad_conf();
    tmr2_conf();
    port_conf();
    int_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Square wave gen.", 16);
    while(1){
        ADCON0bits.GODONE = 1;              //Tomamos una muestra en AN0 a través de A/D
        while(ADCON0bits.GODONE == 1);       //Esperamos a que termine de convertir el A/D
        PR2 = ADRESH;                       //Transferimos el dato ADRESH a PR2
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("PR2:", 4);
        convierte(PR2);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt(high_priority) TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;   //acción de complemento al puerto
    PIR1bits.TMR2IF = 0;            //Bajo la bandera de TMR2
}