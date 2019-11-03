    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000
    goto inicion
    
    org 0x0020
inicion:
    bcf TRISB, 0		    ;El puerto por donde saldrá la onda de 1KHz
    movlw 0xC0
    movwf T0CON			    ;Timer0 ON con PSC1:2 y FOSC/4
looper:
    ;movlw 0x06
    movlw d'13'
    movwf TMR0L
otro:
    btfss INTCON, TMR0IF	    ;Pregunto si se levanto la bandera de desborde del TMR0
    goto otro
    nop
    nop
    btg LATB, 0			    ;Se desbordó TMR0 y cambiamos el valor de RD0
    bcf INTCON, TMR0IF		    ;Bajamos la bandera de desborde
    goto looper
    end
    
    
    


;    alterno:
;    btfss INTCON, TMR0IF
;    goto alterno
;    btfss PORTB, 0
;    goto escero
;    bcf LATB, 0
;    goto final
;escero:
;    bsf LATB, 0
;final:
;    bcf INTCON, TMR0IF
;    goto looper