    PROCESSOR 18F4550
    #include "cabecera.inc"
    
temporal EQU 000H	    ;Etiqueta temporal hacia GPR 000H
 
    PSECT principal, class=CODE, reloc=2, abs
principal:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    movlw 0F0H
    movwf TRISD		    ;Puertos RD(3:0) como salidas, el resto entradas
    bcf INTCON2, 7	    ;Activando weak pullup de puerto B
    
loop:
    movf PORTB, w	    ;muevo contenido de PORTB hacia Wreg
    movwf temporal	    ;muevo contenido de Wreg hacia temporal
    movlw 01H
    andwf temporal, f	    ;enmascaramiento AND entre Wreg y temporal, resultado en temporal
    movf temporal, f	    ;pasamos temporal por CPU para actualizar flag Z
    btfss STATUS, 2	    ;preguntamos si flag Z=1
    goto no_es_cero	    ;falso, salta a no_es_cero
    movlw 06H		    ;verdad, escribe 06H en LATD
    movwf LATD	
    goto loop		    ;Retorna a hacer de nuevo
no_es_cero:
    movlw 09H		    ;escribe 09H en LATD
    movwf LATD	
    goto loop		    ;Retorna a hacer de nuevo
    
    end principal


