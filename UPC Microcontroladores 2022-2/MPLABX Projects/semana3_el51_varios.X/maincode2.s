    PROCESSOR 18F4550
    #include "cabecera.inc"

temporal EQU 000H	;GPR 000H con etiqueta temporal
 
    PSECT camote, class=CODE, reloc=2, abs
camote:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;RBPU=0 res weak pull-up en RB activadas
    
lazo:
    movf PORTB, w	;mueve contenido de PORTB a Wreg
    movwf temporal	;mueve contenido de Wreg a temporal
    movlw 0FH		;cargo contante 0FH en Wreg
    andwf temporal, f	;enmascaramiento AND a temporal con valor 0FH
    xorwf temporal, f	;operación XOR con valor 0FH hacia temporal para invertir accion de los botones
    movlw 06H		;cargo a Wreg el valor de 6
    cpfseq temporal	;comparo temporal=6
    goto no_es_igual	;falso, salta a etiqueta no_es_igual
    bsf LATC, 0		;verdadero, RC0=1
    goto lazo		;retorno al inicio
no_es_igual:
    bcf LATC, 0		;RC0=0
    goto lazo		;retorno al inicio
    
    end camote




