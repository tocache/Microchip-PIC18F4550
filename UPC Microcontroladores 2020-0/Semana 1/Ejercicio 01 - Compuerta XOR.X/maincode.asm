    list p=18f4550		;Modelo del microcontrolador
    #include<p18f4550.inc>	;Libreria de nombre de registros
    
    ;Aquí van los bits de configuracion
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de RESET
    goto configuro		;Salto a etiqueta
    
    org 0x0020			;Zona de programa de usuario
configuro:
    ;Lo primero que tengo que hacer es declarar
    ;RB0 como salida:
    movlw 0xFE
    movwf TRISB
inicio:
    btfss PORTB, 1  ;Pregunto si RB1 es uno
    goto falso1
    btfss PORTB, 2  ;Pregunto si RB2 es uno
    goto falso2
    bcf LATB, 0	    ;Cuando ambas entradas son uno
    goto inicio
falso2:
    bsf LATB, 0	    ;Cuando RB1=1 y RB2=0
    goto inicio
falso1:
    btfss PORTB, 2  ;Pegunto si RB2 es uno
    goto falso3
    bsf LATB, 0	    ;Cuando RB1=0 y RB2=1
    goto inicio
falso3:
    bcf LATB, 0	    ;Cuando ambas entradas son cero
    goto inicio
    end
    


