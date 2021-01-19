;Este es un comentario
    list p=18f4550
    #include <p18f4550.inc>	;libreria de nombre de los registros sfr
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    org 0x0000		    ;Vector de reset
    goto configuro
    
    org 0x0020		    ;Zona de programa de usuario
configuro:
    bcf TRISD, 0    ;RD0 como salida
    bcf TRISD, 1    ;RD1 como salida
    
inicio:
    btfss PORTB, 0  ;pregunta si rb0 es uno
    goto falso1	    ;viene cuando es falso
    bcf LATD, 0	    ;viene aqui cuando es verdadero
    goto otro
falso1:
    bsf LATD, 0
otro:
    btfss PORTB, 1
    goto falso2
    bcf LATD, 1
    goto inicio
falso2:
    bsf LATD, 1
    goto inicio
    end
    
    