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

unsigned char menu1[] = {"Bienvenidos al ejemplo"};
unsigned char menu2[] = {"Seleccione opcion     "};
unsigned char menu3[] = {"(1) Enciende LED      "};
unsigned char menu4[] = {"(2) Apaga LED         "};
unsigned char menu5[] = {"(m) Muestra el menu   "};
unsigned char ledon[] = {"LED encendido         "};
unsigned char ledof[] = {"LED apagado           "};

unsigned char indicador = 0;

void PORT_config(void){
    TRISBbits.RB7 = 0;          //Salida en RB7
}

void EUSART_config(void){
    SPBRGH = 0;                 //Ignorado debido a que BRG16=0
    SPBRG = 77;                 //Vtx es 9600 baudios
    TRISCbits.RC6 = 0;          //Puerto RC6 como salida, no es necesario
    RCSTAbits.SPEN = 1;         //Encendemos el puerto serial
    TXSTAbits.TXEN = 1;         //Encendemos el transmisor
    RCSTAbits.CREN = 1;         //Encendemos el receptor
}

void INT_config(void){
    INTCONbits.GIE = 1;         //Interruptor global habilitado
    INTCONbits.PEIE = 1;        //Interruptor de perifericos habilitado
    PIE1bits.RCIE = 1;          //Habilitado interrupcion por recepcion del EUSART
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
    EUSART_enviacadena(menu1,22);
    EUSART_siguientelinea();        
    EUSART_enviacadena(menu2,22);
    EUSART_siguientelinea();        
    EUSART_enviacadena(menu3,22);
    EUSART_siguientelinea();        
    EUSART_enviacadena(menu4,22);
    EUSART_siguientelinea();        
    EUSART_enviacadena(menu5,22); 
    EUSART_siguientelinea();   
}

void main(void) {
    PORT_config();
    EUSART_config();
    INT_config();
    show_menu();
    while(1);
}

void __interrupt(high_priority) RC_Isr(void){
    PIR1bits.RCIF = 0;
    if(RCREG == '1'){
        LATBbits.LB7 = 1;
        EUSART_enviacadena(ledon,22);
        EUSART_siguientelinea(); 
    }
    else if(RCREG == '2'){
        LATBbits.LB7 = 0;
        EUSART_enviacadena(ledof,22);
        EUSART_siguientelinea();         
    }
    else if(RCREG == 0X6D){
        show_menu();
    }
}
