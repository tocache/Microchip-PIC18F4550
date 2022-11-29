#pragma config PLLDIV = 2, CPUDIV = OSC1_PLL2, USBDIV = 2
#pragma config FOSC = HSPLL_HS, FCMEN = OFF, IESO = OFF
#pragma config PWRT = OFF, BOR = OFF, BORV = 3, VREGEN = OFF
#pragma config WDT = OFF
#pragma config WDTPS = 32768
#pragma config CCP2MX = ON, PBADEN = OFF, LPT1OSC = OFF, MCLRE = ON
#pragma config STVREN = ON, LVP = OFF, ICPRT = OFF, XINST = OFF
#pragma config CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF
#pragma config CPB = OFF, CPD = OFF
#pragma config WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF
#pragma config WRTC = OFF, WRTB = OFF, WRTD = OFF
#pragma config EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF
#pragma config EBTRB = OFF

#define _XTAL_FREQ 48000000
#include <xc.h>
#include <stdio.h>
#include <stdint.h>

#include "lcd.h"                            // Libreria de la pantalla lcd

int8_t min = 0, seg = 0, cen = 0;           // Almacena minutos, segundos, centesimas de segundo
short modo = 0;
short st_mode = 0;
short st_desc = 0;
char buf_lcd[18];

void main()
{
    ADCON1bits.PCFG = 0x0F;                 // Configura todos los pines como digitales
    TRISAbits.RA0 = 1;                      // Pin RA0 como entrada (boton modo)
    TRISAbits.RA1 = 1;                      // Pin RA1 como entrada (boton inicio/pausa)
    TRISAbits.RA2 = 1;                      // Pin RA2 como entrada (boton set/reset)
    TRISBbits.RB0 = 0;                      // Pin RB0 como salida (buzzer)
    TRISBbits.RB2 = 0;                      // Pin RB2 como salida (cuenta ascendente)
    TRISBbits.RB3 = 0;                      // Pin RB3 como salida (cuenta descendente)
    LATBbits.LB0 = 0;
    LATBbits.LB2 = 1;
    LATBbits.LB3 = 0;
    INTCONbits.GIE = 1;                     // Habilita la interrupciones globales
    INTCONbits.TMR0IE = 1;                  // Habilita la interrupcion del timer 0
    INTCONbits.TMR0IF = 0;                  // Flag 0
    T0CON = 0x07;                           // Configuracion del timer 0
    TMR0 = 65067;                           // Carga para 10 milisegundos
    Lcd_Init();                             // Inicializa la pantalla lcd
    
    Lcd_Set_Cursor(4,1);
    Lcd_Write_String("CRONOMETRO");
    Lcd_Set_Cursor(5,2);
    sprintf(buf_lcd, "%02d:%02d:%02d", min, seg, cen);
    Lcd_Write_String(buf_lcd);
    
    while(1)
    {
        if(PORTAbits.RA0 == 1 && st_mode == 0)
        {
            __delay_ms(5);
            while(PORTAbits.RA0 == 1);
            __delay_ms(20);
            modo = !modo;
            
            switch(modo)
            {
                case 0:
                    min = 0;
                    seg = 0;
                    cen = 0;
                    LATBbits.LB2 = 1;
                    LATBbits.LB3 = 0;
                    break;
                    
                case 1:
                    min = 0;
                    seg = 1;
                    cen = 0;
                    LATBbits.LB2 = 0;
                    LATBbits.LB3 = 1;
                    break;
            }
            Lcd_Set_Cursor(5,2);
            sprintf(buf_lcd, "%02d:%02d:%02d", min, seg, cen);
            Lcd_Write_String(buf_lcd);
        }
        
        if(PORTAbits.RA1 == 1)
        {
            __delay_ms(5);
            while(PORTAbits.RA1 == 1);
            __delay_ms(20);
            st_mode = !st_mode;
            
            switch(st_mode)
            {
                case 0:
                    T0CONbits.TMR0ON = 0;
                    LATBbits.LB0 = 1;
                    __delay_ms(150);
                    LATBbits.LB0 = 0;
                    break;
                    
                case 1:
                    LATBbits.LB0 = 1;
                    __delay_ms(150);
                    LATBbits.LB0 = 0;
                    T0CONbits.TMR0ON = 1;
                    break;
            }
        }
        
        if(PORTAbits.RA2 == 1 && st_mode == 0)
        {
            __delay_ms(5);
            while(PORTAbits.RA2 == 1);
            __delay_ms(20);
            
            if(modo == 0){
                min = 0;
                seg = 0;
                cen = 0;
            }else{
                __delay_ms(5);
                while(PORTAbits.RA2 == 1);
                __delay_ms(20);
                
                seg++;
                if(seg > 59){
                    seg = 0;
                    min++;
                    if(min > 59){
                        min = 0;
                        seg = 0;
                    }
                }
            }
            Lcd_Set_Cursor(5,2);
            sprintf(buf_lcd, "%02d:%02d:%02d", min, seg, cen);
            Lcd_Write_String(buf_lcd);
        }
        
        if(st_mode == 1)
        {
            Lcd_Set_Cursor(5,2);
            sprintf(buf_lcd, "%02d:%02d:%02d", min, seg, cen);
            Lcd_Write_String(buf_lcd);
        }
        
        if(st_desc == 1)
        {
            T0CONbits.TMR0ON = 0;
            LATBbits.LB2 = 1;
            LATBbits.LB3 = 0;
            modo = 0;
            min = 0;
            seg = 0;
            cen = 0;
            Lcd_Set_Cursor(5,2);
            sprintf(buf_lcd, "%02d:%02d:%02d", min, seg, cen);
            Lcd_Write_String(buf_lcd);
            st_mode = 0;
            st_desc = 0;
            
            for(short i=0; i<2; i++)
            {
                LATBbits.LB0 = 1;
                __delay_ms(100);
                LATBbits.LB0 = 0;
                __delay_ms(100);
            }
            LATBbits.LB0 = 1;
            __delay_ms(300);
            LATBbits.LB0 = 0;
        }
    }
}

void __interrupt() INT_TMR0(void)           // Interrupcion del timer 0
{
    if(INTCONbits.TMR0IF == 1)
    {
        if(modo == 0)
        {
            cen++;
            if(cen > 99){
                cen = 0;
                seg++;
                if(seg > 59){
                    seg = 0;
                    min++;
                    if(min > 59){
                        min = 0;
                    }
                }
            }
        }
        else
        {
            cen--;
            if(cen <= -1){
                cen = 99;
                seg--;
                if(seg <= -1){
                    seg = 59;
                    min--;
                    if(min <= -1){
                        min = 0;
                        seg = 0;
                        cen = 0;
                        st_desc = 1;
                    }
                }
            }
        }
        TMR0 = 65067;
        INTCONbits.TMR0IF = 0;
    }
}