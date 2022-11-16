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

#define DISPARO 1
#define ESPERA_FLANCO_SUB 2
#define ESPERA_FLANCO_BAJ 3
#define CALCULAR          4
#define MOSTRAR_DISTANCIA 5
unsigned char estado = 0;
float tiempo=0.00;
unsigned int distancia = 0;

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    TRISCbits.RC1 = 0;
    LATCbits.LC1 = 1;
    LATBbits.LB3 = 1;
    TRISEbits.RE0 = 0;
    LATEbits.LE0 = 0;
    CCP1CON = 0x05; //Entrada CAPTURA FLANCO SUB.
    T1CON = 0x91;//Prescaler =8,TMR1ON lecutra 16 bits
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR1IE=1;
    PIE1bits.CCP1IE=1;
    estado = DISPARO;
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

void vis_DHT11(void){
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

void pulso_10us(void){
    LATEbits.LE0 = 1;
    __delay_us(10);
    LATEbits.LE0 = 0;
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Sem 14 Finale",13);
    while(1){
        //vis_DHT11();
        switch(estado)
        {
            case DISPARO:
                LATEbits.LE0=1;
                __delay_us(10);
                LATEbits.LE0=0;
                estado=ESPERA_FLANCO_SUB;
                break;
            case CALCULAR:
                tiempo=(float)distancia;
                tiempo=tiempo*8*0.0833;
                tiempo=tiempo*0.017;
                distancia = (int)tiempo;
                estado = MOSTRAR_DISTANCIA;
                break;
            case MOSTRAR_DISTANCIA:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Dist: ",6);
                ENVIA_CHAR(distancia/100+'0');
                ENVIA_CHAR((distancia%100)/10+'0');
                ENVIA_CHAR((distancia%100)%10+'0');
                ESCRIBE_MENSAJE(" cm",3);
                __delay_ms(20);
                estado = DISPARO;
                break;
        }
    }
}

void __interrupt() CCP1_TMR1(void){
    char dato=0;
    if(PIR1bits.CCP1IF==1){
        PIR1bits.CCP1IF=0;
        switch(estado)
        {
            case ESPERA_FLANCO_SUB:
                TMR1H=0;
                TMR1L=0;
                CCP1CON=0x04;
                estado = ESPERA_FLANCO_BAJ;
                break;
            case ESPERA_FLANCO_BAJ:
                distancia=CCPR1;
                estado = CALCULAR;
                CCP1CON = 0x05;
                break;
        }
        
    }
    else if(PIR1bits.TMR1IF==1){
        PIR1bits.TMR1IF=0;
    }
}
/*

    TRISBbits.TRISB0=0;//RB0 salida=ECHO
    LATB=0;
    CCP2CON = 0x05; //Entrada CAPTURA FLANCO SUB.
    T1CON = 0xB1;//Prescaler =8,TMR1ON lecutra 16 bits
    PIE1bits.TMR1IE=1;
    PIE2bits.CCP2IE=1;
    Abrir_Serial(_9600);
    estado = DISPARO;
    while(1)
    { 
        switch(estado)
        {
            case DISPARO:
                LATBbits.LATB0=1;
                __delay_us(10);
                LATBbits.LATB0=0;
                estado=ESPERA_FLANCO_SUB;
                break;
            case CALCULAR:
                tiempo=(float)distancia;
                tiempo=tiempo*8*0.0833;
                tiempo=tiempo*0.017;
                distancia = (int)tiempo;
                estado = MOSTRAR_DISTANCIA;
                break;
            case MOSTRAR_DISTANCIA:
                TX_MENSAJE_EUSART("\fCms: ",5);
                TX_CHAR_EUSART(distancia/100+'0');
                TX_CHAR_EUSART((distancia%100)/10+'0');
                TX_CHAR_EUSART((distancia%100)%10+'0');
                __delay_ms(20);
                estado = DISPARO;
                break;
        }
    }
}
void interrupt high_priority mis_interr(void)
{
    char dato=0;
    if(PIR2bits.CCP2IF==1)
    {
        PIR2bits.CCP2IF=0;
        switch(estado)
        {
            case ESPERA_FLANCO_SUB:
                TMR1H=0;
                TMR1L=0;
                CCP2CON=0x04;
                estado = ESPERA_FLANCO_BAJ;
                break;
            case ESPERA_FLANCO_BAJ:
                distancia=CCPR2;
                estado = CALCULAR;
                CCP2CON = 0x05;
                break;
        }
        
    }
    else if(PIR1bits.TMR1IF==1)
    {
        PIR1bits.TMR1IF=0;
    }
    else if(PIR1bits.RC1IF==1)
    {
        dato = RCREG;
    }
}
 * 
 * 
 * 
 * */
