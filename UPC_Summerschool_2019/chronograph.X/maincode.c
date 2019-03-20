//This is a comment
/*This is another comment*/

// PIC18F4550 Configuration Bit Settings

// 'C' source line config statements
#pragma config FOSC = XT_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#include "LCD.h"

#define _XTAL_FREQ 4000000UL   //Main frequency obtained from PLL module

char decmin = 0;
char unimin = 0;
char decseg = 0;
char uniseg = 0;
char decima = 0;
char centes = 0;

void main(void){
        T1CON = 0xB1;
        CCP1CON = 0x0B;
        CCPR1H = 0x04;
        CCPR1L = 0xE2;
        INTCON = 0xC0;
        PIE1 = 0x04;
        TRISD = 0x00;       //Para el LCD
        __delay_ms(10);
        LCD_CONFIG();       //Configuracion inicial para usar el LCD
        __delay_ms(10);
        BORRAR_LCD();
        CURSOR_ONOFF(OFF);  //Apagamos el cursor en el LCD
        CURSOR_HOME();      //Movemos el cursor al inicio del LCD (pos 0,0)
        ESCRIBE_MENSAJE("Clock:", 6);
        while(1){
            POS_CURSOR(1,7);
            ENVIA_CHAR(decmin + 0x30);
            ENVIA_CHAR(unimin + 0x30);
            ENVIA_CHAR(0x27);
            ENVIA_CHAR(decseg + 0x30);
            ENVIA_CHAR(uniseg + 0x30);
            ENVIA_CHAR(0x22);
            ENVIA_CHAR(decima + 0x30);
            ENVIA_CHAR(centes + 0x30);
            }
}

void __interrupt(high_priority) CCP1ISR(void){
    if (centes == 9){
        centes = 0;
        if (decima == 9){
            decima = 0;
            if (uniseg == 9){
                uniseg = 0;
                if (decseg == 5){
                    decseg = 0;
                    if (unimin == 9){
                        unimin = 0;
                        if (decmin == 5){
                            decmin = 0;
                        }
                        else{
                            decmin++;
                        }
                    }
                    else{
                        unimin++;
                    }
                }
                else{
                    decseg++;
                }
            }
            else{
                uniseg++;
            }
        }
        else{
            decima++;
        }    
    }
    else{
        centes++;
    }
    PIR1bits.CCP1IF = 0;
}