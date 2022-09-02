    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT maracuya, class=CODE, reloc=2, abs
maracuya:
    ORG 000000H
    bra configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7	    ;weak pullup en RB encendido
    bcf TRISC, 0	    ;RC0 como salida
    bcf LATC, 0		    ;forzando RC0=0 al inicio
inicio:
    btfsc PORTB, 1	    ;pregunto si machuque boton RB1
    bra $-2		    ;falso, vuelvo a preguntar
    btg LATC, 0		    ;verdad, basculo RC0
    btfss PORTB, 1	    ;pregunto si solte el boton RB1
    bra $-2		    ;falso, vuelvo a preguntar
    bra inicio		    ;regreso a inicio
    end maracuya


