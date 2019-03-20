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

    org 0x100
table_7s db 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff	
 
    org 0x0000			;Reset vector address
    goto beginning
    
    org 0x0020			;User program area
beginning:
    clrf TRISD			;Port RD as outputs
    movlw UPPER table_7s
    movwf TBLPTRU
    movlw HIGH table_7s
    movwf TBLPTRH
    movlw LOW table_7s
    movwf TBLPTRL
    
loop:
    clrf TBLPTRL
    movf PORTB, W		;Read port RB and store to W register
    andlw 0x0F
    addwf TBLPTRL, f
    TBLRD*
    movff TABLAT, LATD
    goto loop

    end
    