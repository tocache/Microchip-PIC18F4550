    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000			;Vector de RESET
    goto inicion
    
    org 0x0008			;Vector de interrupcion de alta prioridad o por defecto
    goto enterrop
    
    org 0x0020
inicion:
    bcf TRISD, 0		    ;El puerto por donde saldrá la onda de 1KHz
    movlw 0xC0
    movwf T0CON			    ;Timer0 ON con PSC1:2 y FOSC/4
    movlw 0xA0
    movwf INTCON		    ;Habilito GIE y TMR0IE (Interrupiones)
looper:
    ;sleep
    goto looper
    
enterrop:
    btg LATD, 0
    nop
    movlw 0x0C
    movwf TMR0L
    bcf INTCON, TMR0IF
    retfie
    end