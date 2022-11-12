#include "cabecera.h"
#include "LCD.h"
#include <string.h>
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//Variables y constantes globales
unsigned char mensaje1[] = {"Hola mundo"};
unsigned char mensaje2[] = {"Mi nombre es Kalun Jose Lau Gan"};

void init_conf(void){
    
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

void EUSART_conf(void){
    TRISCbits.RC6 = 0;       //RC6 como salida (TX del EUSART)
    SPBRGH = 0;
    SPBRG = 77;             //Baudrate = 9600
    RCSTAbits.SPEN = 1;     //Puerto serial encendido
    TXSTAbits.TXEN = 1;     //Transmisor encendido
}

void SER_ESCRIBE_MSG(const char *cadena){
    unsigned char tam = 0;
    tam = strlen(cadena);
    unsigned char x = 0;
    for(x=0;x<tam;x++){
        TXREG = cadena[x];
        while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    }
}

void NEXT_LINE(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
}

void main(void) {
    init_conf();
    lcd_init();
    EUSART_conf();
    SER_ESCRIBE_MSG(mensaje1);
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE(mensaje1);
    NEXT_LINE();
    SER_ESCRIBE_MSG(mensaje2);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE(mensaje2);
    while(1);
}
