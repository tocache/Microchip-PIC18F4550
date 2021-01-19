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
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

unsigned char menu1[] = {"Bienvenido al ejemplo de la semana 13"};
unsigned char menu2[] = {"Elija la opcion a ejecutar           "};
unsigned char menu3[] = {"r - Enciende el motor                "};
unsigned char menu4[] = {"p - Apaga el motor                   "};
unsigned char menu5[] = {"m - muestra menu                     "};
unsigned char motoron[] = {"Motor funcionando                  "};
unsigned char motorof[] = {"Motor detenido                     "};
unsigned char errores[] = {"Tecla incorrecta, intente de nuevo "};



unsigned char indicador = 0;

void PORT_config(void){
    TRISEbits.RE0 = 0;          //RE0 salida
    ADCON1 = 0x0F;              //Puertos ANx en digital
}

void EUSART_config(void){
    SPBRGH = 0;                 //Ignorado debido a que BRG16=0
    SPBRG = 77;
    TRISCbits.RC6 = 0;          //Puerto RC6 como salida, no es necesario
    RCSTAbits.SPEN = 1;         //Encendemos el puerto serial
    TXSTAbits.TXEN = 1;         //Encendemos el transmisor
    RCSTAbits.CREN = 1;         //Encendemos el receptor
}

void INT_config(void){
    INTCONbits.GIE = 1;         //Interruptor general habilitado
    INTCONbits.PEIE = 1;        //Interruptor de perifericos habilitado
    PIE1bits.RCIE = 1;          //Habilitador de interrupciones de recepcion en EUSART
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

void show_menu(void){
    EUSART_enviacadena(menu1,37);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu2,37);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu3,37);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu4,37);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu5,37);
    EUSART_siguientelinea();
}

void main(void) {
    EUSART_config();
    INT_config();
    PORT_config();
    show_menu();
    while(1);
}

void __interrupt(high_priority) RC_Isr(void){
    if(RCREG == 0x72){
        LATEbits.LE0 = 1;
        EUSART_enviacadena(motoron,37);
        EUSART_siguientelinea();        
    }
    else if(RCREG == 0x70){
        LATEbits.LE0 = 0;
        EUSART_enviacadena(motorof,37);
        EUSART_siguientelinea();        
    }
    else if(RCREG == 0x6D){
        show_menu();
    }
    else{
        EUSART_enviacadena(errores,37);
        EUSART_siguientelinea();        
    }
}