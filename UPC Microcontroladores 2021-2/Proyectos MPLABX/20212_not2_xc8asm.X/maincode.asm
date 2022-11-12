	PROCESSOR 18F4550
	
	#include "cabecera.inc"
	
	PSECT principal
	
	org 0x0000
	goto configuro	    ;Salto a label configuro
	
	org 0x0020
configuro:  	
	bsf TRISB, 0	    ;RB0 como entrada
	bcf TRISD, 0	    ;RD0 como salida
inicio:
	btfss PORTB, 0	    ;Pregunta si RB0 es uno
	goto falso	    ;Cuando falso, salta a label falso
	bcf LATD, 0	    ;Cuando verdad, pone RD0 en 0
	goto inicio	    ;Vuelvo a ejecutar saltando a label inicio
falso:	bsf LATD, 0	    ;Pone RD0 en 1
	goto inicio	    ;Vuelvo a ejecutar saltando a label inicio
	end

