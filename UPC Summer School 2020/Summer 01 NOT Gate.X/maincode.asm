;My first program
;Coded by Kalun    
;This program emulates a NOT gate on a PIC18F4550 microcontroller    
    list p=18f4550	    ;Processor model
    #include<p18f4550.inc>  ;Library for register names of the selected processor

;Configuration bit declaration
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000		    ;RESET Vector
    goto set_up		    ;Jump to set_up label

    org 0x0020		    ;User program
set_up:    
    bcf TRISD, 0	    ;RD0 as output
begin:    
    btfss PORTB, 0	    ;Test RB0
    goto false		    ;When RB0=0
    bcf LATD, 0		    ;When RB0=1
    goto begin		    ;Infinite loop
false:
    bsf LATD, 0
    goto begin		    ;Infinite loop
    end
    
    


