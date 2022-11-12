    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT code
    org 0x0000
resetVec:    
    goto configuro
    
    org 0x0020
 
configuro:  bsf TRISB, 2, 0	;RB2 como entrada
	    bcf TRISD, 2, 0	;RD2 como salida
inicio:	    btfss PORTB, 2, 0	;Pregunto si RB2 es uno
	    goto noes		;Falso, salta a label noes
	    bcf LATD, 2, 0	;Verdad, RD2 a cero
	    goto inicio		;Salta a label inicio
noes:	    bsf LATD, 2, 0	;RD2 a uno
	    goto inicio		;Salta a label inicio
	    
	    end resetVec


