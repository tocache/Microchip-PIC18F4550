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
    bsf LATD, 0		;Encendemos LED en RD0

inicio:
    bsf LATC, 0
    movlw 0C8H
    movwf T0CON		;Timer0 ON, 1:1, Fosc/4, 8bit
    movlw 6
    movwf TMR0L		;Carga de cuenta inicial 6 en Timer0
otro:
    btfss INTCON, 2	;Preguntamos si se desbordo Timer0 (TMR0IF=1)
    goto otro		;falso, vuelve a preguntar
    bcf INTCON, 2	;bajamos bandera TMR0IF
inicio2:
    bcf LATC, 0		;verdad, bascula RC0
    movlw 0C1H
    movwf T0CON		;Timer0 ON, 1:4, Fosc/4, 8bit
    movlw 69
    movwf TMR0L		;Carga de cuenta inicial 6 en Timer0
otro2:
    btfss INTCON, 2	;Preguntamos si se desbordo Timer0 (TMR0IF=1)
    goto otro2		;falso, vuelve a preguntar
    bcf LATC, 0		;verdad, bascula RC0
    bcf INTCON, 2	;bajamos bandera TMR0IF
    goto inicio
    end cuadradito
    




