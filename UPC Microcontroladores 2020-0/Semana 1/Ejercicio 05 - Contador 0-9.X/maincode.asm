    list p=18f4550
    #include<p18f4550.inc>

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

cuenta EQU 0x00
 
    org 0x0000
    goto configuro
    
    org 0x0020
configuro:
    movlw 0x80
    movwf TRISB

reseteo:    
    clrf cuenta
    movf cuenta, W
    call tabla
    movwf LATB
inicio:
    btfss PORTD, 0
    goto inicio
    movlw .9
    cpfseq cuenta
    goto aunno
    goto yafue
aunno:    
    incf cuenta, f
    movf cuenta, W
    call tabla
    movwf LATB
    goto otro
yafue:
    clrf cuenta
    movf cuenta, W
    call tabla
    movwf LATB
otro:    
    btfsc PORTD, 0
    goto otro
    goto inicio
    
tabla:
    mullw .2
    movf PRODL, W
    addwf PCL, f
    retlw 0x3F	    ;PCL + 0
    retlw 0x06	    ;PCL + 2
    retlw 0x5B	    ;PCL + 4
    retlw 0x4F	    ;PCL + 6
    retlw 0x66
    retlw 0x6D
    retlw 0x7D
    retlw 0x07
    retlw 0x7F
    retlw 0x67
    
    end