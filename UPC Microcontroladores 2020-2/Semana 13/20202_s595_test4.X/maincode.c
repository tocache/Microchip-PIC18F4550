#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include <string.h>
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

unsigned char upc[]={"UPC Electronica Mecatronica"};

unsigned char menu1[] = {"Bienvenidos al ejemplo "};
unsigned char menu2[] = {"Cadena: "};
unsigned char menu3[] = {"Cantidad de caracteres:"};

unsigned char automatico[] = {0x81, 0x42, 0x24, 0x18, 0x24, 0x42};

unsigned char cantidad = 0;

void init_config(void){
    TRISE = 0x00;               //Todos los RE como salidas
    ADCON1 = 0x0F;              //Todos los AN como digitales
}

void EUSART_config(void){
    SPBRGH = 0;                 //Ignorado debido a que BRG16=0
    SPBRG = 77;                 //Vtx es 9600 baudios
    TRISCbits.RC6 = 0;          //Puerto RC6 como salida, no es necesario
    RCSTAbits.SPEN = 1;         //Encendemos el puerto serial
    TXSTAbits.TXEN = 1;         //Encendemos el transmisor
    RCSTAbits.CREN = 1;         //Encendemos el receptor
}

unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void convierte(unsigned char numero){
    centena = numero / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void EUSART_siguientelinea(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);    
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
}

void EUSART_enviacadena(const unsigned char *vector,unsigned char pos){
    for (unsigned char x=0;x<pos;x++){
        TXREG = vector[x];
        while(TXSTAbits.TRMT == 0);    
    }    
}

void EUSART_enviachar(unsigned char letra){
    TXREG = letra;
    while(TXSTAbits.TRMT == 0);    
}  

void out595(unsigned char datoin){
    int i=0;
    LATEbits.LE0 = 0;               //pin CLK
    LATEbits.LE1 = 0;               //pin DATA
    LATEbits.LE2 = 0;               //pin LATCH
    for (i=7; i>=0; i--)    {
        LATEbits.LE0 = 0;
        if (datoin &(1<<i))    {
            LATEbits.LE1 = 1;
        }
        else{
            LATEbits.LE1 = 0;
        }
        LATEbits.LE0 = 1;
        LATEbits.LE1 = 0;
    }
    LATEbits.LE2 = 1;
    LATEbits.LE0 = 0;  
}

void main(void) {
    init_config();
    EUSART_config();
    while(1){
        cantidad = strlen(upc);
        EUSART_enviacadena(menu1, 23);
        EUSART_siguientelinea();
        EUSART_enviacadena(menu2, 8);
        EUSART_enviacadena(upc, cantidad);
        EUSART_siguientelinea();
        EUSART_enviacadena(menu3, 23);
        convierte(cantidad);
        EUSART_enviachar(centena+0x30);
        EUSART_enviachar(decena+0x30);
        EUSART_enviachar(unidad+0x30); 
        EUSART_siguientelinea();
        for(unsigned int v_var=0;v_var<6;v_var++){
            out595(automatico[v_var]);
            __delay_ms(200);
        }
    }
}
