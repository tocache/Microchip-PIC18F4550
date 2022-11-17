#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char RH_Decimal,RH_Integer;
unsigned char T_Decimal,T_Integer;
unsigned char Checksum;
unsigned char centena,decena,unidad;
unsigned char u_acento[]={0x02,0x04,
                          0x11,0x11,
                          0x11,0x11,
                          0x0E,0x00};

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    TRISEbits.RE1 = 0;
    TRISCbits.RC1 = 0;
    TRISCbits.RC2 = 0;
    LATCbits.LC1 = 1;   //temporal
    TRISBbits.RB4 = 0;
    LATBbits.LB4 = 1;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(17);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(u_acento,0);
}

unsigned char DHT11_ReadData(void){
    unsigned char i;
    unsigned char data = 0;  
    for(i=0;i<8;i++){
        while(!(PORTBbits.RB4 & 1));
        __delay_us(30);         
        if(PORTBbits.RB4 & 1){
            data = ((data << 1) | 1); 
        }
        else{
            data = (data << 1);
        }
        while(PORTBbits.RB4 & 1);
    }
    return data;
}

void DHT11_Start(void){    
    TRISBbits.RB4 = 0;
    LATBbits.LB4 = 0;
    __delay_ms(18);
    LATBbits.LB4 = 1;
    __delay_us(20);
    TRISBbits.RB4 = 1;
}

void DHT11_CheckResponse(){
    while(PORTBbits.RB4 & 1);
    while(!(PORTBbits.RB4 & 1));
    while(PORTBbits.RB4 & 1);
}

void convierte(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void lectura_DHT11(void){
    DHT11_Start();
    DHT11_CheckResponse();
    RH_Integer = DHT11_ReadData();
    RH_Decimal = DHT11_ReadData();
    T_Integer = DHT11_ReadData();
    T_Decimal = DHT11_ReadData();
    Checksum = DHT11_ReadData();
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 14 ",10);
    ENVIA_CHAR(0);
    ESCRIBE_MENSAJE("ltimo",5);    
    while(1){
        lectura_DHT11();
        POS_CURSOR(2,0);
        convierte(T_Integer);
        ESCRIBE_MENSAJE("T:",2);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(0xDF);
        convierte(RH_Integer);        
        ESCRIBE_MENSAJE("C RH:",5);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR('%');
        if(Checksum != (RH_Integer + RH_Decimal + T_Integer + T_Decimal)){
            ESCRIBE_MENSAJE(" ER",3);
        }
        else{
            ESCRIBE_MENSAJE(" OK",3);            
        }
        __delay_ms(500);
    }
}
