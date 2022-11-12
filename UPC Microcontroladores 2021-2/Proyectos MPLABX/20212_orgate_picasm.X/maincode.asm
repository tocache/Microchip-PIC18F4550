    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT code
    org 0x0000		;vector de reset
    goto configuro
    
    org 0x0020		;zona de programa de usuario
configuro:
	    bsf TRISB, 0, 0	;RB0 como entrada
	    bsf TRISB, 4, 0	;RB4 como entrada
	    bcf TRISD, 0, 0	;RD0 como salida
inicio:
	    btfsc PORTB, 0, 0	;Pregunto si RB0 es cero
	    goto falso		;Falso, salta a label falso
	    btfsc PORTB, 4, 0	;Verdadero. Pregunto si RB4 es cero
	    goto falso		;Falso, salta a label falso
	    bcf LATD, 0, 0	;Verdadero. RD0 a 0
	    goto inicio		;Retorna a inicio
falso:	    bsf LATD, 0, 0		;RD0 a 1
	    goto inicio		;Retorna a inicio
	    end			;Fin del programa


