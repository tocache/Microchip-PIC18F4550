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
    btfsc PORTB, 2	;Pregunto si presione boton en RB2
    goto no_presione_RB2    ;falso, salto a no_presione_RB2
    bsf LATC, 0		;verdad, mando RC0 a uno
    goto inicio
no_presione_RB2:
    btfsc PORTB, 3	;Pregunto si presione boton en RB3
    goto inicio		;falso, retorna a inicio
    bcf LATC, 0		;verdad, mando RC0 a cero
    goto inicio
    end oyuquito

