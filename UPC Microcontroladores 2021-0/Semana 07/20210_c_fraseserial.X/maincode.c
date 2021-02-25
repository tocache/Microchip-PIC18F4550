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
#include <stdio.h>
#include <string.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

unsigned char menu_1[] = {"Bienvenidos a la aplicacion"};
unsigned char menu_2[] = {"Elija opcion:"};
unsigned char menu_3[] = {"(1) Ingrese mensaje"};
unsigned char menu_4[] = {"(2) Visualiza el mensaje ingresado"};
unsigned char menu_7[] = {"(m) Visualizar el menu"};

unsigned char msg_ingreso[] = {"Ingrese mensaje y luego pulse ENTER:"};
unsigned char msg_ingreso_ack[] = {"Mensaje ingresado"};
unsigned char msg_emision[] = {"El mensaje ingresado fue:"};

unsigned char error[] = {"Tecla invalida, intente de nuevo"}; //32 caracteres

unsigned char msg_input[32] = {0};
unsigned char menu_state = 0;

unsigned char num_char = 0;

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void init_config(void){
    TRISDbits.RD6 = 0;
    TRISDbits.RD7 = 0;
    INTCONbits.GIE = 1;     //Interruptor global de interrupciones ON
    INTCONbits.PEIE = 1;    //Interruptor de interrupciones de perifericos ON
    PIE1bits.RCIE = 1;      //Habilitamos las interrupciones del receptor del EUSART
}

void EUSART_config(void){
    SPBRGH = 0;                 //Ignorado debido a que BRG16=0
    SPBRG = 21;                 //33600 baudios
    TRISCbits.RC6 = 0;          //Puerto RC6 como salida, no es necesario
    RCSTAbits.SPEN = 1;         //Encendemos el puerto serial
    TXSTAbits.TXEN = 1;         //Encendemos el transmisor
    RCSTAbits.CREN = 1;         //Encendemos el receptor
}

void EUSART_siguientelinea(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);    
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
}

void EUSART_enviacadena(const unsigned char *vector){
    unsigned char cantidad = 0;
    cantidad = strlen(vector);
        for (unsigned char x=0;x<cantidad;x++){
            TXREG = vector[x];
            while(TXSTAbits.TRMT == 0);    
        }    
}

void EUSART_enviachar(unsigned char papa){
    TXREG = papa;
    while(TXSTAbits.TRMT == 0);    
}

void vis_menu(void){
    EUSART_enviacadena(menu_1);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu_2);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu_3);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu_4);
    EUSART_siguientelinea();
    EUSART_enviacadena(menu_7);
    EUSART_siguientelinea();
}

void main(void) {
    init_config();
    lcd_init();
    EUSART_config();
    vis_menu();
    EUSART_siguientelinea();
    while(1);
}

void __interrupt() RC_ISR(void){
    PIR1bits.RCIF = 0;
    if (menu_state == 0){
        switch(RCREG){
            case '1':
                EUSART_enviacadena(msg_ingreso);
                EUSART_siguientelinea();
                num_char = 0;
                menu_state = 1;
                break;
            case '2':
                EUSART_enviacadena(msg_emision);
                EUSART_siguientelinea();
                EUSART_enviacadena(msg_input);
                EUSART_siguientelinea();
                CURSOR_HOME();
                for(unsigned char x=0;x<17;x++){
                    ENVIA_CHAR(msg_input[x]);                    
                }
                vis_menu();
                EUSART_siguientelinea();
                menu_state = 0;
                break;
            case 'm':
                vis_menu();
                EUSART_siguientelinea();
                menu_state = 0;
                break;
            default:
                EUSART_enviacadena(error);
                EUSART_siguientelinea();            
                menu_state = 0;
        }
    }
    else{
        if  (RCREG == 0x0D){
            menu_state = 0;
            EUSART_enviacadena(msg_ingreso_ack);
            EUSART_siguientelinea();
            vis_menu();
            EUSART_siguientelinea();
        }
        else{
            msg_input[num_char] = RCREG;
            EUSART_enviachar('*');
            num_char++;
        }
    }    
}    
    
    