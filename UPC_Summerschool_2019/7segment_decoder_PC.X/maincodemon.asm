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

var_temp EQU 0x0020		;Temporal variable
 
    org 0x0000			;Reset vector address
    goto beginning
    
    org 0x0020			;User program area
beginning:
    clrf TRISD			;Port RD as outputs
loop:
    movf PORTB, W		;Read port RB and store to W register
    andlw 0x0F			;Value masking for the 4 least significant bits
    movwf var_temp		;Move Wreg value to var_temp
    addwf var_temp, W		;Add Wreg value to var_temp and store on Wreg
    call table_7s
    movwf LATD
    goto loop

table_7s:
    addwf PCL, f
    retlw 0x40		;0
    retlw 0x79		;1
    retlw 0x24		;2
    retlw 0x30		;3
    retlw 0x19		;4
    retlw 0x12		;5
    retlw 0x02		;6
    retlw 0x78		;7
    retlw 0x00		;8
    retlw 0x18		;9
    retlw 0xff		
    retlw 0xff		
    retlw 0xff		
    retlw 0xff		
    retlw 0xff		
    retlw 0xff		
    end