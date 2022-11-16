#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char RH_Decimal,RH_Integer,T_Decimal;
unsigned char T_Integer,Checksum;
unsigned char centenas,decenas,unidades;
unsigned char okay[]={0x1F,0x11,0x1F,0x00,0x1F,
                        0x0C,0x0A,0x11};
unsigned char erro[]={0x1F,0x15,0x15,0x00,0x1F,
                        0x05,0x0D,0x17};

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    TRISCbits.RC1 = 0;
    LATCbits.LC1 = 1;
    LATBbits.LB3 = 1;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(16);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(okay,0);
    GENERACARACTER(erro,1);
}    

void convierte(unsigned char numero){
    centenas = numero / 100;
    decenas = (numero % 100) / 10;
    unidades = numero % 10;
}

void DHT11_Start(void)  {    
    TRISBbits.RB3 = 0;
    LATBbits.LB3 = 0;
    __delay_ms(18);
    LATBbits.LB3 = 1;
    __delay_us(20);
    TRISBbits.RB3 = 1;
}

unsigned char DHT11_ReadData()  {
  unsigned char i;
  unsigned char data = 0;  
  for(i=0;i<8;i++)
    {
        while(!(PORTBbits.RB3 & 1));
        __delay_us(30);         
        if(PORTBbits.RB3 & 1){
            data = ((data << 1) | 1); 
        }
        else{
            data = (data << 1);  
        }
        while(PORTBbits.RB3 & 1);
    }
  return data;
}

void DHT11_CheckResponse(void)  {
    while(PORTBbits.RB3 & 1);
    while(!(PORTBbits.RB3 & 1));
    while(PORTBbits.RB3 & 1);
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Sem 14 Finale",13);
    while(1){
        POS_CURSOR(2,0);        
        DHT11_Start();
        DHT11_CheckResponse();
        RH_Integer = DHT11_ReadData();
        RH_Decimal = DHT11_ReadData();
        T_Integer = DHT11_ReadData();
        T_Decimal = DHT11_ReadData();
        Checksum = DHT11_ReadData();
        convierte(RH_Integer);
        ESCRIBE_MENSAJE("RH:", 3);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ESCRIBE_MENSAJE("% T:", 4);
        convierte(T_Integer);
        ENVIA_CHAR(decenas + 0x30);
        ENVIA_CHAR(unidades + 0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        if(Checksum != (RH_Integer + RH_Decimal + T_Integer + T_Decimal)){
            ENVIA_CHAR(' ');
            ENVIA_CHAR(1);
        }
        else{
            ENVIA_CHAR(' ');
            ENVIA_CHAR(0);
        }
        __delay_ms(500);
    }
}
