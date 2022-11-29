#define _XTAL_FREQ 48000000
#include <xc.h>
#include "lcd.h"

void Lcd_Init(void)
{
    RS_DIR = 0;
    EN_DIR = 0;
    D4_DIR = 0;
    D5_DIR = 0;
    D6_DIR = 0;
    D7_DIR = 0;
    RS_PIN = 0;
    EN_PIN = 0;
    D4_PIN = 0;
    D5_PIN = 0;
    D6_PIN = 0;
    D7_PIN = 0;
    __delay_ms(20);
    
    for(unsigned char i=0; i<3; i++)
    {
        Lcd_Send_Nibble(0x03);
        __delay_ms(5);
    }
    Lcd_Cmd(0x33);
    Lcd_Cmd(0x32);
    Lcd_Cmd(0x28);
    Lcd_Cmd(0x0C);
    Lcd_Cmd(0x06);
	Lcd_Cmd(0x01);
    __delay_ms(3);
}

void Lcd_Send_Nibble(unsigned char nibble)
{
    if((nibble & 1)==1) D4_PIN = 1; else D4_PIN = 0;
    if((nibble & 2)==2) D5_PIN = 1; else D5_PIN = 0;
    if((nibble & 4)==4) D6_PIN = 1; else D6_PIN = 0;
    if((nibble & 8)==8) D7_PIN = 1; else D7_PIN = 0;
    
    EN_PIN = 1;
    __delay_us(50);
    EN_PIN = 0;
}

void Lcd_Cmd(unsigned char cmd)
{
    RS_PIN = 0;
    Lcd_Send_Nibble(cmd >> 4);
    Lcd_Send_Nibble(cmd & 0x0F);
    __delay_us(100);
}

void Lcd_Write_Char(char dat)
{
    RS_PIN = 1;
    Lcd_Send_Nibble(dat >> 4);
    Lcd_Send_Nibble(dat & 0x0F);
    __delay_us(100);
}

void Lcd_Set_Cursor(unsigned char  x, unsigned char  y)
{
    unsigned char address;
    switch(y)
    {
        case 1:
            address = 0x00;
            break;
        case 2:
            address = 0x40;
            break;
        case 3:
            address = 0x14;
            break;
        case 4:
            address = 0x54;
            break;
    }
    address += x - 1;
    Lcd_Cmd(0x80 | address);
}

void Lcd_Write_String(const char *str)
{
    while(*str != '\0')
    {
        Lcd_Write_Char(*str++);
    }
}

void Lcd_Clear(void)
{
    Lcd_Cmd(0x01);
    __delay_ms(2);
}

void Lcd_Blink(void)
{
    Lcd_Cmd(0x0F);
}

void Lcd_NoBlink(void)
{
    Lcd_Cmd(0x0C);
}

void Lcd_Shift_Right(void)
{
	Lcd_Cmd(0x1C);
}

void Lcd_Shift_Left(void)
{
	Lcd_Cmd(0x18);
}

void Lcd_CGRAM_CreateChar(unsigned char pos, const char*msg)
{
    if(pos < 8)
    {
        Lcd_Cmd(0x40 + (pos*8));
        for(unsigned char i=0; i<8; i++)
        {
            Lcd_Write_Char(msg[i]);
        }
    }
}

void Lcd_CGRAM_WriteChar(char pos)
{
    Lcd_Write_Char(pos);
}