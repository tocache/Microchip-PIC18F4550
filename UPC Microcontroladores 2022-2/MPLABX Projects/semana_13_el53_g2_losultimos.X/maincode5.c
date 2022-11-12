#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char efectos[]={0x02,0x05,0x01,
                        0x02,0x04,0x02,
                        0x01,0x04,0x00,
                        0x07,0x00,0x01,
                        0x02,0x03,0x04,
                        0x05,0x06,0x07,
                        0x06,0x05,0x04,
                        0x03,0x02,0x01};
unsigned char estado_vis=0;
unsigned char estado_vel=0;
unsigned char LED_OFF1[]={0x0F,0x10,0x10,
                        0x10,0x10,0x10,
                        0x0F,0x00};
unsigned char LED_OFF2[]={0x1E,0x01,0x01,
                        0x01,0x01,0x01,
                        0x1E,0x00};
unsigned char LED_ON2[]={0x1E,0x1D,0x1F,
                        0x1F,0x1F,0x1D,
                        0x1E,0x00};
unsigned char LED_ON1[]={0x0F,0x17,0x1F,
                        0x1F,0x1F,0x17,
                        0x0F,0x00};
unsigned char mensaje[]={"Ya nos vamos!"};

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    CMCON = 0x07;
    CVRCON = 0x00;
    TRISE = 0xF8;
    RCONbits.IPEN = 1;
    INTCONbits.GIEH = 1;
    INTCONbits.GIEL = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
    INTCON3bits.INT1IE = 1;
    INTCON2bits.INTEDG1 = 0;
    SPBRG = 12;
    RCSTAbits.SPEN = 1;
    TXSTAbits.TXEN = 1;
    INTCON3bits.INT2IE = 1;
    INTCON2bits.INTEDG2 = 0;
    INTCON3bits.INT2IP = 0;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(24);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(LED_OFF1,0);
    GENERACARACTER(LED_OFF2,1);
    GENERACARACTER(LED_ON1,2);
    GENERACARACTER(LED_ON2,3);
}

void vis_LEDs_LCD(void){
    POS_CURSOR(2,0);
    if(PORTEbits.RE2==0){
        ENVIA_CHAR(0);
        ENVIA_CHAR(1);
    }
    else{
        ENVIA_CHAR(2);
        ENVIA_CHAR(3);
    }
    ENVIA_CHAR(' ');
    if(PORTEbits.RE1==0){
        ENVIA_CHAR(0);
        ENVIA_CHAR(1);
    }
    else{
        ENVIA_CHAR(2);
        ENVIA_CHAR(3);
    }    
    ENVIA_CHAR(' ');
    if(PORTEbits.RE0==0){
        ENVIA_CHAR(0);
        ENVIA_CHAR(1);
    }
    else{
        ENVIA_CHAR(2);
        ENVIA_CHAR(3);
    }
}

void retardo_vis(void){
    switch(estado_vel){
        case 0:
            __delay_ms(80);
            break;
        case 1:
            __delay_ms(200);
            break;
        case 2:
            __delay_ms(400);
            break;
    }
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Viernes Cultural",16);
    while(1){
        unsigned char x;
        switch(estado_vis){
            case 0:
                for(x=0;x<2;x++){
                    LATE=efectos[x];
                    vis_LEDs_LCD();
                    retardo_vis();
                }
                break;
            case 1:
                for(x=2;x<6;x++){
                    LATE=efectos[x];
                    vis_LEDs_LCD();
                    retardo_vis();
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE=efectos[x];
                    vis_LEDs_LCD();
                    retardo_vis();
                }
                break;
            case 3:
                for(x=8;x<10;x++){
                    LATE=efectos[x];
                    vis_LEDs_LCD();
                    retardo_vis();
                }
                break;
            case 4:
                for(x=10;x<18;x++){
                    LATE=efectos[x];
                    vis_LEDs_LCD();
                    retardo_vis();
                }
                break;
            case 5:
                for(x=17;x<24;x++){
                    LATE=efectos[x];
                    vis_LEDs_LCD();
                    retardo_vis();
                }
                break;
        }
    }
}

void __interrupt(high_priority) INT0INT1_ISR(void){
    if(INTCONbits.INT0IF == 1){
        INTCONbits.INT0IF = 0;
        if(estado_vis == 5){
            estado_vis = 0;
        }
        else{
            estado_vis++;
        }
    }
    if(INTCON3bits.INT1IF == 1){
        INTCON3bits.INT1IF = 0;
        if(estado_vel == 2){
            estado_vel = 0;
        }
        else{
            estado_vel++;
        }
    }
}

void __interrupt(low_priority) INT2_ISR(void){
    INTCON3bits.INT2IF = 0;
    unsigned char z;
    for(z=0;z<13;z++){
        TXREG = mensaje[z];
        while(TXSTAbits.TRMT == 0);
    }
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
}
