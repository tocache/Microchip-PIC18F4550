;Este es un comentario
    
    list p=18f4550
    #include "p18f4550.inc"
    
    CONFIG  FOSC = XT_XT        ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON           ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF           ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF           ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF        ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF           ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Reset vector
    goto inicio
    
    org 0x0020			;Zona de programa de usuario
inicio:
    bcf TRISD, 0		;Puerto D0 como salida
looper:
    btfss PORTB, 0		;Pregunto si RB0 es uno
    goto nope
    goto sipe
    
nope:
    btfss PORTB, 1		;Pregunto si RB1 es uno
    goto nope1
    bcf LATD, 0			;Combinación 0-1
    goto looper

nope1:
    bcf LATD, 0			;Combinación 0-0
    goto looper
    
sipe:
    btfss PORTB, 1		;Pregunto si RB1 es uno
    goto nope2
    bsf LATD, 0			;Combinación 1-1
    goto looper

nope2:
    bcf LATD, 0			;Combinación 1-0
    goto looper
    end
    
