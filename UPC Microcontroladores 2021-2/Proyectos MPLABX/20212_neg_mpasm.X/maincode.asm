
    PROCESSOR 18F4550
    ;#include <p18f4550.inc>
    #include "cabecera.inc"
    
	org 0x0000	    ;Vector reset
	goto configuro	    ;Salta a la etiqueta configuro
	
	org 0x0020	    ;Zona del programa de usuario
configuro:	
	    bsf TRISB, 0    ;Puerto RB0 como entrada
	    bcf TRISD, 0    ;Puerto RD0 como salida
inicio:
	    btfss PORTB, 0  ;Pregunto si RB0 es uno
	    goto falso	    ;Viene aqui cuando es falso
	    bcf LATD, 0	    ;Viene aqui cuando es verdadero. Mando RD0 a cero
	    goto inicio	    ;Salto a inicio
falso:	    bsf LATD, 0	    ;Mando RD0 a uno
	    goto inicio	    ;Salto a inicio
	    end		    ;Fin del programa

