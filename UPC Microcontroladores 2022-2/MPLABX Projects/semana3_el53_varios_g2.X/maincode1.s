    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT ciruela, class=CODE, reloc=2, abs
ciruela:
    ORG 000000H
    goto configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7	;Activamos weak pullup en RB
    bcf TRISC, 0	;RC0 como salida
inicio:
    btfsc PORTB, 3	;Pregunto si RB3 es cero
    goto no_machuque_RB3    ;Falso, salta a etiqueta indicada
    bcf LATC, 0		;Verdad, apago el LED en RC0
    goto inicio		;retorno a inicio
no_machuque_RB3:
    btfsc PORTB, 2	;Pregunto si RB2 es cero
    goto inicio		;Falso, retorna a inicio
    bsf LATC, 0		;Verdad, enciendo LED en RC0
    goto inicio
    end ciruela