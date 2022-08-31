#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

//declaracion de variables globales
unsigned char ticks = 0;
unsigned char segundos = 0;
unsigned char minutos = 49;     //hora inicial
unsigned char horas = 21;       //minuto inicial
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void configuro(void){
    T1CON = 0x31;           //Timer1 ON, PSC 1:8, FOSC/4
    CCP1CON = 0x0B;         //Comparator Special Event Trigger
    CCPR1H = 0x27;
    CCPR1L = 0x10;          //Compare value at 10000
    INTCON = 0xC0;          //GIEH=1 PEIE=1
    PIE1 = 0x04;            //CCP1IE=1
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void muestra_hora(void){
        POS_CURSOR(2,0);
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
        ENVIA_CHAR(':');
        convierte(ticks);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        //visualización del reloj
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Reloj UPC 2022-1",16);
        muestra_hora();
    }
}

void __interrupt() CCP1_ISR(void){
    if (ticks == 99){
        ticks = 0;
        if (segundos == 59){
            segundos = 0;
            if (minutos == 59){
                minutos = 0;
                if (horas == 23){
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