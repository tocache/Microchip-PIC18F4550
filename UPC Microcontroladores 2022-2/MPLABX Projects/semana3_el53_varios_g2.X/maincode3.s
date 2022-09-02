    PROCESSOR 18F4550
    #include "cabecera.inc"

temporal EQU 000H	;nombre temporal a GPR 000H    
    
    PSECT ciruela, class=CODE, reloc=2, abs
ciruela:
    ORG 000000H
    goto configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7	;weak pullup activados en RB
    bcf TRISC, 0
    
inicio:
    movf PORTB, w	;muevo contenido de PORTB a Wreg
    movwf temporal	;muevo Wreg a temporal
    movlw 0FH		;cargo 0FH en Wreg
    andwf temporal, f	;enmascaramiento 0FH a temporal
    movlw 5		;cargamos 5 en Wreg
    cpfseq temporal	;comparamos temporal = wreg
    goto no_es_igual	;falso, saltamos a label indicado
    bsf LATC, 0		;verdad, prendemos LED en RC0
    goto inicio		;retornamos a inicio
no_es_igual:
    bcf LATC, 0		;apagamos LED en RC0
    goto inicio		;retornamos a inicio
    end ciruela


