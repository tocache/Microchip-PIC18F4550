//Este es un comentario
//Bits de configuracion o directivas de preprocesador
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 32000000UL   //Frecuencia de trabajo actual
#include <xc.h>

unsigned char cadena[] = {"Electronica - Mecatronica"};
unsigned char menu1[] = {"Bienvenidos al menu "};
unsigned char menu2[] = {"Escoja opcion:      "};
unsigned char menu3[] = {"(1) Enciendes LED   "};
unsigned char menu4[] = {"(2) Apagas LED      "};
unsigned char menu5[] = {"(3) Parpadeas LED   "};
unsigned char menu6[] = {"(4) Estado del boton"};
unsigned char menu7[] = {"(5) Autor           "};
unsigned char menu8[] = {"(6) Envia MSG al LCD"};
unsigned char menu9[] = {"(m) Visualizar menu "};
unsigned char autor[] = {"Kalun Jose Lau Gan  "};
unsigned char led_on[] = {"LED encendido       "};
unsigned char led_off[] = {"LED apagado         "};
unsigned char led_parpadeo[] = {"LED parpadeando     "};
unsigned char boton_on[] = {"Boton presionado    "};
unsigned char boton_off[] = {"Boton sin presionar "};
unsigned char error[] = {"Tecla erronea       "};
unsigned char input_cadena[] = {"Ingrese MSG (max 16 letras) seguido de un $"};
unsigned char msg_registrado[] = {"MSG registrado:"};
unsigned char recibido[15];
unsigned char indice = 0;
unsigned char estado = 0;


void send_string(const unsigned char *vector, unsigned int numero){
    for(unsigned char i=0;i<numero;i++){
        TXREG = vector[i];
        while(TXSTAbits.TRMT == 0);
    }
}

void send_char(unsigned char letrita){
    TXREG = letrita;
    while(TXSTAbits.TRMT == 0);
}

void send_newline(void){
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;    
    while(TXSTAbits.TRMT == 0);
}

void uc_config(void){
        //Para configurar la velocidad a 9600 con 32MHz
    BAUDCONbits.BRG16 = 0;
    TXSTAbits.SYNC = 0;
    TXSTAbits.BRGH = 0;
    SPBRGH = 0;
    SPBRG = 51;
    TXSTAbits.TXEN = 1;     //Habilitamos la transmision en el EUSART
    RCSTAbits.CREN = 1; //Habilitamos el receptor del EUSART
    RCSTAbits.SPEN = 1;         //Encendemos el EUSART
    TRISCbits.RC6 = 0;
    INTCONbits.GIE = 1;     //Habilitamos interrupciones globales
    INTCONbits.PEIE = 1;        //Habilitamos interrupciones de perifericos
    PIE1bits.RC1IE = 1;         //Habilitamos interrupciojn de recepcion en EUSART
    ADCON1 = 0x0F;          //Para que los puertos RA y RE sean digitales
    TRISEbits.RE0 = 0;      //Salida para el LED
}

void show_menu(void){
    send_string(menu1,20);
    send_newline();
    send_string(menu2,20);
    send_newline();
    send_string(menu3,20);
    send_newline();
    send_string(menu4,20);
    send_newline();
    send_string(menu5,20);
    send_newline();
    send_string(menu6,20);
    send_newline();
    send_string(menu7,20);
    send_newline();
    send_string(menu8,20);
    send_newline();
    send_string(menu9,20);
    send_newline();
}

void parpadeo(void){
    while(PIR1bits.RC1IF == 0){
        LATEbits.LE0 = 1;
        __delay_ms(200);
        LATEbits.LE0 = 0;
        __delay_ms(200);
    }
}

void main(void){
    uc_config();
    send_char('U');
    send_char('P');
    send_char('C');
    send_newline();
    send_string(cadena,25);
    send_newline();
    while(1);
}

void __interrupt () RCIsr(void){
    PIR1bits.RC1IF = 0;
    if (estado == 0){
        switch(RCREG){
            case '1':
                send_string(led_on,20);
                send_newline();
                LATEbits.LE0 = 1;
                estado = 0;
                break;
            case '2':
                send_string(led_off,20);
                send_newline();
                LATEbits.LE0 = 0;
                estado = 0;
                break;
            case '3':
                send_string(led_parpadeo,20);
                send_newline();
                parpadeo();
                estado = 0;
                break;
            case '4':
                if(PORTBbits.RB0 == 1){
                    send_string(boton_on,20);
                    send_newline();
                }
                else{
                    send_string(boton_off,20);
                    send_newline();
                }
                estado = 0;
                break;
            case '5':
                send_string(autor,20);
                send_newline();
                estado = 0;
                break;
            case '6':
                send_string(input_cadena,43);
                send_newline();
                //registro_cadena();
                estado = 1;
                break;
            case 'm':
                show_menu();
                send_newline();
                estado = 0;
                break;            
            default:
                send_string(error,20);
                send_newline();
                estado = 0;
        }
    }
    else{
        if (RCREG == '$'){
            indice = 0;
            send_string(msg_registrado,15);
            //send_newline();
            for (unsigned int ww=0;ww<16;ww++){
                TXREG = recibido[ww];
                while(TXSTAbits.TRMT == 0);
            }
            send_newline();            
            estado = 0;
        }
        else{
            recibido[indice] = RCREG;
            indice++;
        }
    }
}