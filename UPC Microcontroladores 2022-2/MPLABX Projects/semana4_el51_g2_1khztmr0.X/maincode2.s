    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT chocolate, class=CODE, reloc=2, abs
chocolate:
    ORG 000000H
    bra configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf TRISB, 0	;RB0 como salida
inicio:
    bsf LATB, 0		;RB0 en uno
ton:
    bsf LATC, 0
    movlw 0C8H
    movwf T0CON		;Timer0 ON, fosc/4, psc 1:2, 8bit
    movlw 56
    movwf TMR0L		;Carga de cuenta inicial 6 en Timer0
otro:
    btfss INTCON, 2	;Pregunto si se desbordo Timer0
    bra $-2		;falso, retorna a preguntar
    bcf INTCON, 2	;verdad, bajamos bandera TMR0IF
tof:
    bcf LATC, 0
    movlw 0C1H
    movwf T0CON		;Timer0 ON, fosc/4, psc 1:2, 8bit
    movlw 56
    movwf TMR0L		;Carga de cuenta inicial 6 en Timer0
otro2:
    btfss INTCON, 2	;Pregunto si se desbordo Timer0
    bra $-2		;falso, retorna a preguntar
    bcf INTCON, 2	;verdad, bajamos bandera TMR0IF
    bra ton
    end chocolate
    
    
    





