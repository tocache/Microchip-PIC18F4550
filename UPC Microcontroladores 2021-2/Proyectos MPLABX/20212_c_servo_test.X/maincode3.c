#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

unsigned int cta_on = 6000; 
unsigned int cta_off = 0;
unsigned int cta_inicial = 5535;
unsigned int temp = 0;
float escalamiento = 0;

void init_conf(void){
    TRISBbits.RB5 = 0;
    T0CON = 0x81;    
    INTCON = 0xA0;   
    ADCON2 = 0x24;   
    ADCON1 = 0x0D;    
    ADCON0bits.ADON = 1;  
}

void main(void) {
    unsigned int res_ad_an0 = 0;
    init_conf();
    while(1){
        ADCON0 = 0x03;     
        while(ADCON0bits.GODONE == 1);
        res_ad_an0 = (((ADRESH << 8) + ADRESL) >> 6) & 0x03FF;
        escalamiento = 3000 + res_ad_an0 * 4.39;
        cta_on = escalamiento;
        cta_off = 60000 - cta_on;
    };
}

void __interrupt() TMR0_ISR(void){
    if(PORTBbits.RB5 ==1){
        LATBbits.LB5 = 0;
        TMR0H = ((cta_inicial + cta_on) >> 8) & 0x00FF;
        TMR0L = (cta_inicial + cta_on) & 0x00ff;
    }
    else{
        LATBbits.LB5 = 1;
        TMR0H = ((cta_inicial + cta_off) >> 8) & 0x00FF;
        TMR0L = (cta_inicial + cta_off) & 0x00ff;        
    }
    INTCONbits.TMR0IF = 0;
}