#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char efecto[] = {0x01,0x02,0x04,0x02,0x03,0x06,0x00,0x07};
unsigned char estado = 0;
unsigned char LED_OFF[] = {0x0E,0x11,0x11,0x11,0x11,0x0A,0x0E,0x0E};
unsigned char LED_ON[] = {0x0E,0x1F,0x1F,0x1F,0x1F,0x0E,0x0E,0x0E};
unsigned char mensaje1[] = {"Hola mundo"};
unsigned char mensaje2[] = {"UPC Electronica"};
unsigned char mensaje3[] = {"UPC Mecatronica"};
unsigned char estado2 = 0;

void configuro(void){
    OSCCON = 0x70;  //Reloj a 8MHz
    ADCON1 = 0x0F;  //Todos los ANx como digitales
    TRISE = 0xF8;   //RE0:RE2 como salidas
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;
    INTCONbits.GIEL = 1;
    INTCON2bits.RBPU = 0;       //weak pullup activados en RB
    INTCONbits.INT0IE = 1;      //habilitador INT0
    INTCON2bits.INTEDG0 = 0;    //flanco descendente en INT0
    INTCON3bits.INT1IE = 1;     //habilitador INT1
    INTCON3bits.INT1IP = 0;     //baja prioridad a INT1
    INTCON2bits.INTEDG1 = 0;    //flanco descendente en INT1
    SPBRG = 12;                 //baudrate a 9600
    RCSTAbits.SPEN = 1;         //activamos el puerto serial
    TXSTAbits.TXEN = 1;         //activamos el transmisor del puerto serial
    TRISCbits.RC6 = 0;          //RC6 como salida para que funcoione TX
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(16);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(LED_OFF, 0);
    GENERACARACTER(LED_ON, 1);
}

void vis_LED(void){
    POS_CURSOR(2,5);
    if(PORTEbits.RE2 == 0){
        ENVIA_CHAR(0);
    }
    else{
        ENVIA_CHAR(1);
    }
    if(PORTEbits.RE1 == 0){
        ENVIA_CHAR(0);
    }
    else{
        ENVIA_CHAR(1);
    }
    if(PORTEbits.RE0 == 0){
        ENVIA_CHAR(0);
    }
    else{
        ENVIA_CHAR(1);
    }
}

void NEW_LINE_EUSART(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
}
void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 13",9);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("LEDs:",5);
    while(1){
        unsigned char x;
        switch(estado){
            case 0:
                for(x=0;x<4;x++){
                    LATE = efecto[x];
                    vis_LED();
                    __delay_ms(200);                    
                }
                break;
            case 1:
                for(x=4;x<6;x++){
                    LATE = efecto[x];
                    vis_LED();
                    __delay_ms(200);                    
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE = efecto[x];
                    vis_LED();
                    __delay_ms(200);                    
                }
                break;
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado == 2){
        estado = 0;
    }
    else{
        estado++;
    }
    __delay_ms(90);
}

void __interrupt(low_priority) INT1_ISR(void){
    INTCON3bits.INT1IF = 0;
    unsigned char y;
    switch(estado2){
        case 0:
            for(y=0;y<10;y++){
                TXREG = mensaje1[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
        case 1:
            for(y=0;y<15;y++){
                TXREG = mensaje2[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
        case 2:
            for(y=0;y<15;y++){
                TXREG = mensaje3[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
    }
    NEW_LINE_EUSART();
    if(estado2 == 2){
        estado2 = 0;
    }
    else{
        estado2++;
    }    
}