    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT ciruela, class=CODE, reloc=2, abs
ciruela:
    ORG 000000H
    goto configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7	;weak pullup en RB activados
    bcf TRISC, 0	;RC0 como salida
inicio:
    btfsc PORTB, 1	;pregunto si machuque el boton RB1
    goto inicio		;falso, vuelve a preguntar
    btg LATC, 0		;verdad, basculo RC0
otro:
    btfss PORTB, 1	;pregunto si soltaste el boton RB1
    goto otro
    goto inicio
    end ciruela


