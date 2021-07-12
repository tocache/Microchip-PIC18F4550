#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#include "dht11_lib.h"

#define _XTAL_FREQ 48000000UL

unsigned char RH_Entera, RH_Decimal, Temp_Entera, Temp_Decimal, Checksum;
unsigned char centena=0, decena=0, unidad=0;
float n_temp_f=0;

void LCD_Init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned char numero){
    centena = (numero % 1000) / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    LCD_Init();
    ESCRIBE_MENSAJE("Prueba", 6);
    unsigned char x=0;
    for(x=0;x<10;x++){
        ENVIA_CHAR('.');
        __delay_ms(200);
    }
    POS_CURSOR(2,1);
    ESCRIBE_MENSAJE("Todo OK!", 8);
    __delay_ms(3000);
    BORRAR_LCD();
    while(1){
        DHT11_Start();              //Le ordeno al DHT11 activarse y medir
        DHT11_Check();              //Espero respuesta
        
        RH_Entera = DHT11_Read();       //Lectura de los 40 bits
        RH_Decimal = DHT11_Read();
        Temp_Entera = DHT11_Read();
        Temp_Decimal = DHT11_Read();
        Checksum = DHT11_Read();
        CURSOR_HOME();
        ESCRIBE_MENSAJE("RH:",3);
        convierte(RH_Entera);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ESCRIBE_MENSAJE("% Temp:",7);
        convierte(Temp_Entera);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        n_temp_f = (Temp_Entera * 9 / 5) + 32;
        POS_CURSOR(2,6);
        ESCRIBE_MENSAJE("Temp:",5);
        convierte(n_temp_f);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('F');
        
        if(Checksum != (RH_Entera+RH_Decimal+Temp_Entera+Temp_Decimal)){
            BORRAR_LCD();
            CURSOR_HOME();
            ESCRIBE_MENSAJE("Hay Error!!",11);
        }
        __delay_ms(1000);
    }
}
