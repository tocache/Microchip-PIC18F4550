;UPC Summer School 2019
;Template written by Kalun

;In this example we are going to learn how to setup the Timer0 as a timer with
;a time period of 100ms using 16bit mode and 4MHz on main oscillator
    
    list p=18f4550		;The microcontroller of the project
    #include <p18f4550.inc>	;Library for the register's labels
    
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Reset vector address
    goto beginning
    
    org 0x0020			;User program area
beginning:
    bcf TRISD, 0		;Port RD0 as an output
    movlw 0x80			;Timer0 enabled - 1:2 prescaler, 16bit mode, fosc clock source
    movwf T0CON
    
loop:
    movlw 0x3C
    movwf TMR0H
    movlw 0xB0
    movwf TMR0L			;Timer0 initial count = 15536
u2: btfss INTCON, TMR0IF	;Ask if Timer0 did an overflow
    goto u2
    btfss PORTD, 0		;Ask if port RD0 is high
    goto no
    bcf LATD, 0			;Make port RD0 low
    goto u3
no: bsf LATD, 0			;Make port RD0 high
u3: bcf INTCON, TMR0IF		;Low the overflow flag of Timer0    
    goto loop
    end
    