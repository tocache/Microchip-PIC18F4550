    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT oyuquito, class=CODE, reloc=2, abs
temp0 EQU 000H
oyuquito:
    ORG 000000H
    goto configuro

    ORG 000020H
configuro:    
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;RBPU activadas
inicio:
    movf PORTB, w	;muevo PORTB hacia Wreg
    andlw 0FH		;enmascaramiento AND a Wreg con 0FH
    movwf temp0		;muevo Wreg hacia temp0
    movlw 5		;muevo literal 5 a Wreg
    cpfseq temp0	;comparo temp0 = Wreg
    goto falso		;falso salta a label falso
    bsf LATC, 0		;verdad, pone a uno RC0
    goto inicio		;retorna a inicio
falso:
    bcf LATC, 0		;pone a cero RC0
    goto inicio		;retorna a inicio
    end oyuquito

