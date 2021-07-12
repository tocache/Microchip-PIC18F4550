#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#include "dht11_lib.h"

#define _XTAL_FREQ 48000000UL

void ADC_init(void){
    ADCON2 = 0xA4;      //Tiempo de conversion
    ADCON1 = 0x1B;      //Seleccion de los canales analogicos
    ADCON0 = 0x01;      //Encender el modulo A/D
}

void LCD_init(void){
    unsigned char reloj0[]={0x1F,0x1F,0x0E,0x04,0x0A,0x11,0x1F,0x00};
    unsigned char reloj1[]={0x1F,0x1B,0x0E,0x04,0x0A,0x15,0x1F,0x00};
    unsigned char reloj2[]={0x1F,0x11,0x0E,0x04,0x0A,0x1F,0x1F,0x00};
    unsigned char reloj3[]={0x1F,0x11,0x0A,0x04,0x0E,0x1F,0x1F,0x00};
    unsigned char reloj4[]={0x0A,0x12,0x03,0x1F,0x07,0x07,0x06,0x00};
    unsigned char reloj5[]={0x00,0x11,0x1B,0x07,0x1B,0x11,0x00,0x00};
    unsigned char reloj6[]={0x0E,0x0F,0x1F,0x07,0x04,0x14,0x0C,0x00};
    unsigned char reloj7[]={0x1F,0x1F,0x0E,0x04,0x0A,0x11,0x1F,0x00};
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(reloj0, 0);
    GENERACARACTER(reloj1, 1);
    GENERACARACTER(reloj2, 2);
    GENERACARACTER(reloj3, 3);
    GENERACARACTER(reloj4, 4);
    GENERACARACTER(reloj5, 5);    
    GENERACARACTER(reloj6, 6);    
    GENERACARACTER(reloj7, 7);
} 

float LM35_read(void){
    unsigned int lm35raw;      //variable de funcion LM35_read
    float n_temp_c;
    ADCON0bits.GODONE = 1;      //toma de una muestra en AN0
    while(ADCON0bits.GODONE == 1);
    lm35raw = (ADRESH << 8) + ADRESL; //ADRESH:ADRESL
    n_temp_c = lm35raw / 10.24;
    return n_temp_c;
}

void ESCRIBE_VARIABLECHAR_LCD(unsigned char numero){
    unsigned char centena, decena, unidad;  //variables de funcion convierte
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
//    ENVIA_CHAR(centena+0x30);
    ENVIA_CHAR(decena+0x30);
    ENVIA_CHAR(unidad+0x30);
}

void main(void) {
    unsigned char RH_Ent, RH_Dec, Temp_Ent, Temp_Dec, Chksum;
    ADC_init();
    LCD_init();
    ESCRIBE_MENSAJE("Cargando sistema",16);
    unsigned char y=0;
    unsigned char x=0;
    for(y=0;y<5;y++){
        for(x=0;x<8;x++){
            POS_CURSOR(2,0);
            ENVIA_CHAR(x);
            __delay_ms(200);
        }
    }
    ESCRIBE_MENSAJE(" Todo listo!",12);  
    __delay_ms(3000);
    BORRAR_LCD();
    while(1){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("T1:",3);
        ESCRIBE_VARIABLECHAR_LCD(LM35_read());
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C ", 2);
        DHT11_Start();
        DHT11_Check();
        RH_Ent = DHT11_Read();
        RH_Dec = DHT11_Read();
        Temp_Ent = DHT11_Read();
        Temp_Dec = DHT11_Read();
        Chksum = DHT11_Read();
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T2:",3);
        ESCRIBE_VARIABLECHAR_LCD(Temp_Ent);
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C RH:", 5);
        ESCRIBE_VARIABLECHAR_LCD(RH_Ent);
        ENVIA_CHAR('%');
        __delay_ms(1000);
    }
}
