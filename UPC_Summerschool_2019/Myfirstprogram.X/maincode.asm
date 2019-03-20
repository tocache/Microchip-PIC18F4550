;UPC Summer School 2019
;Template written by Kalun
    
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
    movlw 0xfc			;0xfc 0b11111100
    movwf TRISD			;RD1 and RD0 are outputs
loops:
    btfss PORTB, 0		;Asking if RB is 1
    goto no			;Go to this line if NO
yes:				;Jump to this line if YES
    bsf LATD, 0			
    bcf LATD, 1
    goto loops		    
no:
    bcf LATD, 0
    bsf LATD, 1
    goto loops
    end