#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char estado_backlight = 0;
unsigned char RH_Decimal,RH_Integer;
unsigned char T_Decimal,T_Integer;
unsigned char Checksum;
unsigned char centena,decena,unidad;

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    LATCbits.LC2 = 1;       //activacion temporal
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON2bits.RBPU = 0;
    PR2 = 62;
    CCPR1L = 15;
    TRISCbits.RC2 = 0;  
    T2CON = 0x07;
    CCP1CON = 0x0C;
    LATBbits.LB5 = 1;
}

init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

unsigned char DHT11_ReadData(void){
    unsigned char data = 0;  
    unsigned char i;
    for(i=0;i<8;i++){
        while(!(PORTBbits.RB5 & 1));
        __delay_us(30);         
        if(PORTBbits.RB5 & 1){
            data = ((data<<1) | 1); 
        }
        else{
            data = (data<<1);              
        }
        while(PORTBbits.RB5 & 1);
    }
    return data;
}

void DHT11_Start(void){    
    TRISBbits.RB5 = 0;
    LATBbits.LB5 = 0;
    __delay_ms(20);
    LATBbits.LB5 = 1;
    __delay_us(20);
    TRISBbits.RB5 = 1;
}

void DHT11_CheckResponse(void){
    while(PORTBbits.RB5 & 1);
    while(!(PORTBbits.RB5 & 1));
    while(PORTBbits.RB5 & 1);
}

void convierte(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Sem14 AUXILIO!");
    __delay_ms(500);
    while(1){
        DHT11_Start();
        DHT11_CheckResponse();
        RH_Integer = DHT11_ReadData();
        RH_Decimal = DHT11_ReadData();
        T_Integer = DHT11_ReadData();
        T_Decimal = DHT11_ReadData();
        Checksum = DHT11_ReadData();
        POS_CURSOR(2,0);
        convierte(T_Integer);
        ESCRIBE_MENSAJE("T:");
        ENVIA_CHAR(decena+'0');
        ENVIA_CHAR(unidad+'0');
        ENVIA_CHAR(0xDF);
        convierte(RH_Integer);
        ESCRIBE_MENSAJE("C RH:");
        ENVIA_CHAR(decena+'0');
        ENVIA_CHAR(unidad+'0');
        ENVIA_CHAR('%');
        if(Checksum != (RH_Integer+RH_Decimal+T_Integer+T_Decimal)){
            ESCRIBE_MENSAJE(" ER");
        }
        else{
            ESCRIBE_MENSAJE(" OK");
        }
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
            CCPR1L = 0;
            break;
        case 1:
            CCPR1L = 15;
            break;
        case 2:
            CCPR1L = 31;
            break;
        case 3:
            CCPR1L = 46;
            break;
        case 4:
            CCPR1L = 62;
            break;
    }
}
