;Este es un comentario
;Los comentarios se colocan antecediendo el punto y coma
    list p=18f4550	;Modelo de microcontrolador a usar
    #include <p18f4550.inc> ;Libreria de nombre de registros
    
;Declaracion de los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000	    ;Vector de RESET
    goto manyas
    
    org 0x0020	    ;Zona de programa de usuario
manyas:
    movlw 0xFC
    movwf TRISD	    ;RD0 y RD1 como salidas
yapes:
    btfss PORTB, 0  ;Pregunto si RB0 es uno
    goto falso
    movlw 0x01
    movwf LATD
    goto yapes
falso:
    movlw 0x02
    movwf LATD
    goto yapes
    end