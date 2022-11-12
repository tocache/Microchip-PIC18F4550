    PROCESSOR 18F4550

    #include "cabecera.inc"
    
	PSECT codigo
    
	org 0x0000	    ;Vector reset
	goto configuro	    ;Salta a la etiqueta configuro
	
	org 0x0020	    ;Zona del programa de usuario
configuro:
	bsf TRISB, 0	    ;Entrada A
	bsf TRISB, 3	    ;Entraba B
	bcf TRISD, 0	    ;Salida C
inicio:	btfss PORTB, 0	    ;Pregunto si Entrada A=1
	goto falso	    ;Falso, salta a label falso
	btfss PORTB, 3	    ;Verdadero, pregunta si Entrada B=1
	goto falso	    ;Falso, salta a label falso
	bsf LATD, 0	    ;Verdadero, pone RD0 en alto
	goto inicio	    ;Regresa a label inicio
falso:	bcf LATD, 0	    ;Pone RD0 en bajo
	goto inicio	    ;Regresa a label inicio
	end		    ;Fin del programa


