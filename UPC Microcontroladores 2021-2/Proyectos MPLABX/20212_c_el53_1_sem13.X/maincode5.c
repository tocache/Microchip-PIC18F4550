#include "cabecera.h"
#include <string.h>
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//Variables y constantes globales
unsigned char mensaje1[] = {"El parpadeador"};
unsigned char mensaje2[] = {"Ingrese cantidad de veces a parpadear el LED (0-9)"};
unsigned char cantidad = 0;

void init_conf(void){
    TRISDbits.RD0 = 0;      //Salida, conectado a un LED
    INTCONbits.GIE = 1;     //Habilitador global de interrupciones activado
    INTCONbits.PEIE = 1;    //Habilitador de interrupcioens de perifericos activado
    PIE1bits.RCIE = 1;      //Interrupcion de recepcion del EUSART activado
}

void EUSART_conf(void){
    TRISCbits.RC6 = 0;       //RC6 como salida (TX del EUSART)
    SPBRGH = 0;
    SPBRG = 77;             //Baudrate = 9600
    RCSTAbits.SPEN = 1;     //Puerto serial encendido
    TXSTAbits.TXEN = 1;     //Transmisor encendido
    RCSTAbits.CREN = 1;     //Receptor encendido
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
    EUSART_conf();
    __delay_ms(500);
    NEXT_LINE();
    SER_ESCRIBE_MSG(mensaje1);
    NEXT_LINE();
    SER_ESCRIBE_MSG(mensaje2);
    NEXT_LINE();
    while(1);
}

void __interrupt() EUSART_ISR(void){
    PIR1bits.RCIF = 0;
    if((RCREG >= 0x30) && (RCREG <= 0x39)){
        cantidad = RCREG - 0x30;
        unsigned char r = 0;
        for(r=0;r<cantidad;r++){
            LATDbits.LD0 = 1;
            __delay_ms(100);
            LATDbits.LD0 = 0;
            __delay_ms(100);
        }
    }
    else{
        SER_ESCRIBE_MSG("Tecla erronea");
        NEXT_LINE();
    }
}
        
