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
    btfsc PORTB, 2	    ;pregunto si presione boton en RB2
    bra no_machuque_RB2    ;falso, salta a label no_machuque_RB2
    bsf LATC, 0		    ;verdad, enciendo LED en RC0
    bra inicio		    ;retorno a inicio
no_machuque_RB2:
    btfsc PORTB, 3	    ;pregunto si presione boton en RB3
    bra inicio		    ;falso, retorna a inicio
    bcf LATC, 0		    ;apago LED en RC0
    bra inicio		    ;retorno a inicio
    end maracuya


