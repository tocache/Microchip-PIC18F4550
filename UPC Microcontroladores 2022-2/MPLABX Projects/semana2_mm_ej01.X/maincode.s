;Programa hecho por Kalun
;Programa para de la semana 2 para EL52
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT programa, class=CODE, reloc=2, abs

temporal EQU 000H	;Etiqueta para la posicion 000H de mem datos
    
programa:
    ORG 000000H
    goto configuro

    ORG 000020H
configuro:
    movlw 0F0H
    movwf TRISD		    ;Puertos RD3-RD0 como salidas
    bcf INTCON2, 7	    ;Para activar las weak pullup de RB
loop:
;    movf PORTB, w	    ;Primera opcion para mover PORTB a temporal
;    movwf temporal
    movff PORTB, temporal   ;Segunda opcion para mover PORTB a temporal
    movlw 01H
    andwf temporal, f	    ;enmascaramiento AND 01H a temporal
    movf temporal, f	    ;pasamos el temporal por ALU para actualizar banderas
    btfss STATUS, 2	    ;preguntamos si bandera Z se levanto
    goto no_es_cero	    ;falso, salfa a no_es_cero
    movlw 09H		    ;verdad, manda 09H a RD
    movwf LATD		    
    goto loop		    ;regreso al inicio
no_es_cero:
    movlw 06H		    ;manda 06H a RD
    movwf LATD		    
    goto loop		    ;regreso al inicio
    
    end programa
    


