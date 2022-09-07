    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT cuadradito, class=CODE, reloc=2, abs
cuadradito:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf TRISD, 0	;RD0 como salida
    movlw 0C0H
    movwf T0CON		;Timer0 ON, 1:2 PSC, Fosc/4, 8bit
    bsf LATD, 0		;Encendemos LED en RD0

inicio:    
    movlw 6
    movwf TMR0L		;Carga de cuenta inicial 6 en Timer0
otro:
    btfss INTCON, 2	;Preguntamos si se desbordo Timer0 (TMR0IF=1)
    goto otro		;falso, vuelve a preguntar
    btg LATC, 0		;verdad, bascula RC0
    bcf INTCON, 2	;bajamos bandera TMR0IF
    goto inicio
    end cuadradito
    

