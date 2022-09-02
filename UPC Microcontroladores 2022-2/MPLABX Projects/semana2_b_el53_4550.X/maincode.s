    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT zanahoria, class=CODE, reloc=2, abs

temporal EQU 000H	;Etiqueta temporal a GPR 000H    

zanahoria:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    movlw 0F0H
    movwf TRISD		;Puertos RD(3:0) como salidas
    bcf INTCON2, 7	;Activamos las weak pullup del puerto B

loop:
    movf PORTB, w
    movwf temporal	;copiamos contenido de PORTB a temporal
    movlw 01H
    andwf temporal, f	;enmascaramiento AND con 01H a temporal
    movf temporal, f	;movemos hacia si mismo temporal para actualizar flag Z
    btfss STATUS, 2	;pregunto si flag Z es uno
    goto no_es_cierto	;falso, salta a no_es_cierto
    movlw 09H		;cierto, escribe 09H en LATD
    movwf LATD
    goto loop
no_es_cierto:
    movlw 06H		;escribe 06H en LATD
    movwf LATD
    goto loop
    end zanahoria
    


