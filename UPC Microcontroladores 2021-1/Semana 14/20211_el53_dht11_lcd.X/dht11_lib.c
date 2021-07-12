#include "dht11_lib.h"

void DHT11_Start(void){
    TRISBbits.RB0 = 0;      //Puerto RB0 como salida
    LATBbits.LB0 = 0;       //Mandamos cero
    __delay_ms(18);         //Esperamos 18 milisegundos
    LATBbits.LB0 = 1;       //Mandamos uno
    __delay_us(20);         //Esperamos 20 microsegundos
    TRISBbits.RB0 = 1;      //Puerto como entrada
}

void DHT11_Check(void){
    while(PORTBbits.RB0);
    while(!PORTBbits.RB0);
    while(PORTBbits.RB0);
}

unsigned char DHT11_Read(void){
    unsigned char x = 0, data = 0;
    for(x=0;x<8;x++){
        while(!PORTBbits.RB0);
        __delay_us(30);
        if(PORTBbits.RB0){
            data = ((data<<1) | 1);
        }
        else{
            data = (data<<1);
        }
        while(PORTBbits.RB0);
    }
    return data;
}
