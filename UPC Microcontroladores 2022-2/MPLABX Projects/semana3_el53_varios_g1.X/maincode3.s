    PROCESSOR 18F4550
    #include "cabecera.inc"

temporal EQU 000H	    ;GPR 000H con label temporal    

    PSECT maracuya, class=CODE, reloc=2, abs
maracuya:
    ORG 000000H
    goto configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7	    ;weak pullup en RB encendido
    bcf TRISC, 0	    ;RC0 como salida
    bcf LATC, 0		    ;forzando RC0=0 al inicio
inicio:
    movf PORTB, w	    ;muevo PORTB hacia Wreg
    movwf temporal	    ;muevo Wreg hacia GPR temporal
    movlw 0FH
    andwf temporal, f	    ;enmascaramiento AND 0FH hacia temporal
    movlw 05H
    cpfseq temporal	    ;comparo si temporal = 05H
    goto no_es_igual	    ;falso, salto a label no_es_igual
    bsf LATC, 0		    ;verdad, enciendo LED en RC0
    goto inicio		    ;retorno a inicio
no_es_igual:
    bcf LATC, 0		    ;apago LED en RC0
    goto inicio
    end maracuya
    


