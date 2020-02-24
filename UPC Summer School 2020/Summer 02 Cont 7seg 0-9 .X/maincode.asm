;My first program
;Coded by Kalun    
;This program counts from 0 to 9 and shows on a seven segment common cathode display    
    list p=18f4550	    ;Processor model
    #include<p18f4550.inc>  ;Library for register names of the selected processor

;Configuration bit declaration
  CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

cuenta equ 0x20		    ;Variable declaration for counter  
  
    org 0x0600
tabla_7s db 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x67
  
    org 0x0000		    ;RESET Vector
    goto set_up		    ;Jump to set_up label

    org 0x0020		    ;User program
set_up:
    clrf cuenta		    ;Clear cuenta
    clrf TRISD		    ;Set RD port as output
    movlw LOW tabla_7s
    movwf TBLPTRL
    movlw HIGH tabla_7s
    movwf TBLPTRH	    ;Set address location for table pointer
    movlw 0x3f
    movwf LATD		    ;Output initial value of zero to display
begin:
    btfss PORTB, 0
    goto begin
    movlw .9
    cpfseq cuenta
    goto non
    clrf cuenta
    goto outtt
non:incf cuenta, f
outtt:
    movf cuenta, W
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
prep:
    btfsc PORTB, 0
    goto prep
    goto begin
    end
    
    
    
    


