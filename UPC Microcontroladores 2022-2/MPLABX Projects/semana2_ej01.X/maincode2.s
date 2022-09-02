;Programa hecho por Kalun
;Programa para escribir 0AAH en el puerto RD
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT programa, class=CODE, reloc=2, abs
    
programa:
    ORG 000000H		;Vector de RESET
    goto configuro	;Salto a etiqueta configuro
    
    ORG 000020H		;Zona de programa de usuario
configuro:
    movlw 00H	        ;Configurar todo el RD como salida
    movwf TRISD
loop:
    movf PORTB, 1	;Muevo contenido de PORTB hacia si mismo
    btfss STATUS, 2	;Pregunto si bandera Z es igual a uno (numero de entrada = 0)
    goto no_es_cero	;Cuando es falso, salta a no_es_cero
    movlw 0AAH		;Cuando es verdad, escribe 0AAH en RD
    movwf LATD		
    goto loop
no_es_cero:
    movlw 55H		;Escribe 55H en RD
    movwf LATD		
    goto loop
    end programa





