#ifndef LCD_H
#define	LCD_H

#define RS_PIN LATDbits.LD2
#define EN_PIN LATDbits.LD3
#define D4_PIN LATDbits.LD4
#define D5_PIN LATDbits.LD5
#define D6_PIN LATDbits.LD6
#define D7_PIN LATDbits.LD7

#define RS_DIR TRISDbits.TRISD2
#define EN_DIR TRISDbits.TRISD3
#define D4_DIR TRISDbits.TRISD4
#define D5_DIR TRISDbits.TRISD5
#define D6_DIR TRISDbits.TRISD6
#define D7_DIR TRISDbits.TRISD7

void Lcd_Init(void);
void Lcd_Clear(void);
void Lcd_Cmd(unsigned char cmd);
void Lcd_Write_Char(char dat);
void Lcd_Send_Nibble(unsigned char nibble);
void Lcd_Set_Cursor(unsigned char  x, unsigned char  y);
void Lcd_Write_String(const char *str);
void Lcd_Blink(void);
void Lcd_NoBlink(void);
void Lcd_Shift_Right(void);
void Lcd_Shift_Left(void);
void Lcd_CGRAM_WriteChar(char pos);
void Lcd_CGRAM_CreateChar(unsigned char pos, const char*msg);

#endif