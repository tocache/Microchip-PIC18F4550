#include <xc.h>
#include "cabecera.h"
#include "LCD.h"

//declaracion de variables globales
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void init_conf(void){
    //ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    T2CON = 0x45;               //Configuracion de Timer2
    //PR2 = 188;
    PIE1bits.TMR2IE = 1;        //Configuracion de las ints
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
    ADCON2 = 0x24;              //Configuracion del A/D
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void lcd_init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    init_conf();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Generator UPC21",15);
    while(1){
        unsigned char x;
        unsigned int promedio=0;
        for(x=0;x<40;x++){
            ADCON0bits.GODONE = 1;
            while(ADCON0bits.GODONE == 1);
            promedio = promedio + ADRESH;
        }
        promedio = promedio / 40;
        PR2 = promedio;
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("PR2:",4);
        convierte(promedio);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt() TMR2_ISR(){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}