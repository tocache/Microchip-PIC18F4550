    PROCESSOR 18F4550
    #include "cabecera.inc"

temp0 EQU 000H
 
    PSECT cebolla, class=CODE, reloc=2, abs
cebolla:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;Activamos weak pullup de RB
inicio:
    movf PORTB, w	;muevo contenido de RB hacia Wreg
    andlw 0FH		;aplico enmascaramiento AND de 05H a Wreg
    movwf temp0		;muevo Wreg a temp0 (GPR)
    movlw 05H		;muevo 05H a Wreg
    cpfseq temp0	;comparo si temp0 = Wreg
    goto no_es_cinco	;falso, salta a label no_es_cinco
    bsf LATC, 0		;verdad, RC0=1
    goto inicio		;retorna a inicio
no_es_cinco:
    bcf LATC, 0		;RC0=0
    goto inicio		;retorna a inicio
    end cebolla
    


