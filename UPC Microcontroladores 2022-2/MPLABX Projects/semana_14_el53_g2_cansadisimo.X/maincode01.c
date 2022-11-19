#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define LUZ_DE_FONDO LATCbits.LC1
#define PRENDIDO 1
#define APAGAO 0
#define ARRANQUE_LCD init_LCD()
#define CONFIGURACION_INICIAL configuro()
#define _XTAL_FREQ 8000000UL

unsigned char u_acento[]={0x02,0x04,0x11,
                        0x11,0x11,0x11,
                        0x0E,0x00};
unsigned char estado_backlight = 0;
unsigned char T_Integer,T_Decimal,
                RH_Integer,RH_Decimal,
                Checksum;
unsigned char centena,decena,unidad;


void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    LUZ_DE_FONDO = PRENDIDO;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
    PR2 = 124;
    CCPR2L = 0;
    TRISCbits.RC1 = 0;
    T2CON = 0x05;
    CCP2CON = 0x0C;
}

init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(31);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(u_acento,0);
}

unsigned char DHT11_ReadData(void){
    unsigned char i,data = 0;  
    for(i=0;i<8;i++)
    {
        while(!(PORTBbits.RB1 & 1));
        __delay_us(30);         
        if(PORTBbits.RB1 & 1)
            data = ((data<<1) | 1); 
        else
            data = (data<<1);  
        while(PORTBbits.RB1 & 1);
    }
  return data;
}

void DHT11_Start(void){    
    TRISBbits.RB1 = 0;
    LATBbits.LB1 = 1;
    __delay_us(5);
    LATBbits.LB1 = 0;
    __delay_ms(20);
    LATBbits.LB1 = 1;
    __delay_us(20);
    TRISBbits.RB1 = 1;
}

void DHT11_CheckResponse(void){
    while(PORTBbits.RB1 & 1);
    while(!(PORTBbits.RB1 & 1));
    while(PORTBbits.RB1 & 1);
}

void convierte(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    CONFIGURACION_INICIAL;
    ARRANQUE_LCD;
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("UPC Sem14 ");
    ENVIA_CHAR(0);
    ESCRIBE_MENSAJE("ltimo");
    while(1){
        DHT11_Start();
        DHT11_CheckResponse();
        RH_Integer = DHT11_ReadData();
        RH_Decimal = DHT11_ReadData();
        T_Integer = DHT11_ReadData();
        T_Decimal = DHT11_ReadData();
        Checksum = DHT11_ReadData();
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T:");
        convierte(T_Integer);
        ENVIA_CHAR(decena+'0');
        ENVIA_CHAR(unidad+'0');
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C RH:");
        convierte(RH_Integer);
        ENVIA_CHAR(decena+'0');
        ENVIA_CHAR(unidad+'0');
        ENVIA_CHAR('%');
        __delay_ms(1500);
    }
}

void __interrupt() INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado_backlight == 4){
        estado_backlight = 0;
    }
    else{
        estado_backlight++;
    }
    switch(estado_backlight){
        case 0:
            CCPR2L = 0;
            break;
        case 1:
            CCPR2L = 31;
            break;
        case 2:
            CCPR2L = 62;
            break;
        case 3:
            CCPR2L = 93;
            break;
        case 4:
            CCPR2L = 124;
            break;
    }
    __delay_ms(80);
            
}
