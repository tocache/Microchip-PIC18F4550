    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT oyuquito, class=CODE, reloc=2, abs

oyuquito:
    ORG 000000H
    goto configuro

    ORG 000020H
configuro:    
    bcf INTCON2, 7	;RBPU activadas
    movlw 80H
    movwf TRISD		;RD(6:0) como salidas
inicio:
    btfsc PORTB, 0	;Pregunto si presione boton en RB0
    goto no_machuque_RB0
    movlw 3EH
    movwf LATD
    goto inicio
no_machuque_RB0:
    btfsc PORTB, 1	;Pregunto si presione boton en RB1
    goto no_machuque_RB1
    movlw 73H
    movwf LATD
    goto inicio
no_machuque_RB1:
    btfsc PORTB, 2	;Pregunto si presione boton en RB1
    goto no_machuque_RB2
    movlw 39H
    movwf LATD
    goto inicio
no_machuque_RB2:    
    movlw 00H
    movwf LATD
    goto inicio
    end oyuquito
    


