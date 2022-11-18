#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define ENCENDIDO 1
#define APAGADO 0
#define BACKLIGHT CCPR1L
#define BANDERA_INT0 INTCONbits.INT0IF
#define B_000 0
#define B_025 31
#define B_050 62
#define B_075 93
#define B_100 124
#define _XTAL_FREQ 8000000UL

unsigned char estado_backlight = 0;
unsigned char RH_Decimal,RH_Integer;
unsigned char T_Decimal,T_Integer,Checksum;
unsigned char centena, decena, unidad;

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    //LATCbits.LC2 = 1;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
    PR2 = 124;
    BACKLIGHT = B_000;
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(19);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void DHT11_Start(void){    
    TRISBbits.RB5 = 0;
    LATBbits.LB5 = 0;
    __delay_ms(18);
    LATBbits.LB5 = 1;
    __delay_us(20);
    TRISBbits.RB5 = 1;
}

void DHT11_CheckResponse(void){
    while(PORTBbits.RB5 & 1);  /* wait till bus is High */     
    while(!(PORTBbits.RB5 & 1));  /* wait till bus is Low */
    while(PORTBbits.RB5 & 1);  /* wait till bus is High */
}

unsigned char DHT11_ReadData(void){
    unsigned char i;
    unsigned data = 0;  
    for(i=0;i<8;i++){
        while(!(PORTBbits.RB5 & 1));
        __delay_us(30);         
        if(PORTBbits.RB5 & 1){
            data = ((data << 1) | 1); 
        }
        else{
            data = (data << 1);
        }
        while(PORTBbits.RB5 & 1);
    }
  return data;
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
    ESCRIBE_MENSAJE("Sem 14 Lab Micro",16);
    while(1){
        DHT11_Start();
        DHT11_CheckResponse();
        RH_Integer = DHT11_ReadData();
        RH_Decimal = DHT11_ReadData();
        T_Integer = DHT11_ReadData();
        T_Decimal = DHT11_ReadData();
        Checksum = DHT11_ReadData();
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T:",2);
        convierte(T_Integer);
        ENVIA_CHAR(decena+'0');
        ENVIA_CHAR(unidad+'0');
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C RH:",5);
        convierte(RH_Integer);
        ENVIA_CHAR(decena+'0');
        ENVIA_CHAR(unidad+'0');
        ENVIA_CHAR('%');
        __delay_ms(500);
    }
}

void __interrupt() INT0_ISR(void){
    BANDERA_INT0 = APAGADO;
    if (estado_backlight == 4){
        estado_backlight = 0;
    }
    else{
        estado_backlight++;
    }
    switch(estado_backlight){
        case 0:
            BACKLIGHT = B_000;
            break;
        case 1:
            BACKLIGHT = B_025;
            break;
        case 2:
            BACKLIGHT = B_050;
            break;
        case 3:
            BACKLIGHT = B_075;
            break;
        case 4:
            BACKLIGHT = B_100;
            break;
    }
}