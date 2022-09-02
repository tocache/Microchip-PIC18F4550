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
;    movlw 0AAH		;Escribo AAH en el puerto RD}
    movlw 55H		;Escribo 55H en el puerto RD    
    movwf LATD
    goto loop
    
    end programa


