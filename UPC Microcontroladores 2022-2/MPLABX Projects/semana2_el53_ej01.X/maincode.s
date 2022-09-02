    PROCESSOR 18F4550
    #include "cabecera.inc"

temporal EQU 000H	;Etiqueta a GPR 000H    
    
    PSECT principal, class=CODE, reloc=2, abs
principal:
    ORG 000000H
    goto configuro

    ORG 000020H
configuro:
    movlw 0F0H
    movwf TRISD		;RD(3:0) como salidas
    bcf INTCON2, 7	;RBPU activados
    
loop:
    movf PORTB, w	;movemos PORTB a Wreg
    movwf temporal	;movemos Wreg a temporal
    movlw 01H
    andwf temporal, f	;enmascaramiento AND 01H a temporal
    movf temporal, f	;revision de temporal por ALU
    btfss STATUS, 2	;pregunto si Z =1
    goto no_es_cero	;falso, salta a no_es_cero
    movlw 09H		;verdad, arroja 09H en LATD
    movwf LATD
    goto loop
no_es_cero:
    movlw 06H		;arroja 06H en LATD
    movwf LATD
    goto loop
    
    end principal


