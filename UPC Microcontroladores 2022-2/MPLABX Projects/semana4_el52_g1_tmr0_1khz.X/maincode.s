    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT galleta, class=CODE, reloc=2, abs
galleta:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    movlw 0FH
    movwf ADCON1	;Puertos todos en digital
    bcf TRISC, 0	;RC0 como salida
    bcf TRISE, 0	;RE0 como salida
    movlw 0C0H
    movwf T0CON		;Timer0 ON, Fosc/4, 8bit, PSC 1:2
    bsf LATC, 0		;RC0=1

inicio:
    movlw 6
    movwf TMR0L		;Carga de cuenta inicial a Timer0
    btfss INTCON, 2	;Pregunto si TMR0IF=1 (si se desbordo el Timer0)
    bra $-2		;Retorna a preguntar
    bcf INTCON, 2	;Bajamos bandera TMR0IF
    btg LATE, 0		;Bascula salida RE0
    bra inicio		;Retorna a inicio
    end galleta


