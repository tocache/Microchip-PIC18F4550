#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char salida[]={0x01,0x02,0x04,0x02,0x05,0x02,0x03,0x06,0x00,0x07};
unsigned char foco_off[]={0x0E,0x11,0x11,0x11,0x11,0x0A,0x0A,0x0E};
unsigned char foco_on[]={0x0E,0x15,0x1F,0x1F,0x15,0x0E,0x0A,0x0E};
unsigned char mensaje1[]={"hola mundo"};
unsigned char mensaje2[]={"UPC Ingenieria Mecatronica"};
unsigned char mensaje3[]={"UPC Ingenieria Electronica"};
unsigned char mensaje4[]={"UPC Ingenieria Biomedica"};
unsigned char estado1=0;
unsigned char estado2=0;


void configuro(void){
    OSCCON = 0x70;  //reloj a 8MHz
    ADCON1 = 0x0F;  //ANx como digitales
    TRISE = 0xF8;   //RE2:RE0 como salidas
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;     //habilitador global high priority de ints
    INTCONbits.GIEL = 1;     //habilitador global low priority de ints
    INTCONbits.INT0IE = 1;  //habilitador de int0
    INTCON2bits.RBPU = 0;   //weak pullup activadas
    INTCON2bits.INTEDG0 = 0;    //flanco negativo de int0
    INTCON3bits.INT2IP = 0;     //int2 a la baja prioridad
    INTCON2bits.INTEDG2 = 0;    //flanco negativo de int2
    INTCON3bits.INT2IE = 1;     //habilitador de int2
    SPBRG = 12;                 //velocidad 9600 para EUSART
    TRISCbits.RC6 = 0;          //RC6 como salida
    RCSTAbits.SPEN = 1;         //habilitado puerto serial
    TXSTAbits.TXEN = 1;         //habilitado el transmisor del EUSART
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(18);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(foco_off,0);
    GENERACARACTER(foco_on,1);    
}

void vis_focos(void){
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("LEDs:",5);
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

void salto_del_tigre(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("UPC Sem13 2022-2",16);
    while(1){
        unsigned char x;
        switch(estado1){
            case 0:
                for(x=0;x<4;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
            case 1:
                for(x=4;x<6;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
            case 3:
                for(x=8;x<10;x++){
                    LATE = salida[x];
                    vis_focos();
                    __delay_ms(200);
                }
                break;
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado1 == 3){
        estado1 = 0;
    }
    else{
        estado1++;
    }
}

void __interrupt(low_priority) INT2_ISR(void){
    INTCON3bits.INT2IF = 0;
    unsigned char y;
    switch(estado2){
        case 0:
            for(y=0;y<10;y++){
                TXREG = mensaje1[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
        case 1:
            for(y=0;y<26;y++){
                TXREG = mensaje2[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
        case 2:
            for(y=0;y<26;y++){
                TXREG = mensaje3[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
        case 3:
            for(y=0;y<24;y++){
                TXREG = mensaje4[y];
                while(TXSTAbits.TRMT == 0);
            }
            break;
    }
    salto_del_tigre();
    if(estado2 == 3){
        estado2 = 0;
    }
    else{
        estado2++;
    }
}

