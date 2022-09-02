    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT oyuquito, class=CODE, reloc=2, abs

oyuquito:
    ORG 000000H
    goto configuro

    ORG 000020H
configuro:    
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;RBPU activadas
inicio:
    btfsc PORTB, 1	;Pregunto si RB1 es cero
    goto inicio		;falso, retorna a inicio
    btg LATC, 0		;aplico complemento a RC0
otro:
    btfss PORTB, 1	;Pregunto si RB1 es uno
    goto otro		;falso, retorno a otro
    goto inicio
    end oyuquito


