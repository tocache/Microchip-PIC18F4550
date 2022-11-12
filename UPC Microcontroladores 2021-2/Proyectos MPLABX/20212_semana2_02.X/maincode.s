    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT code
    org 0000H
    goto configuro
    
    org 0020H
configuro:
	    bcf TRISD, 0	;Pin RD0 como salida
inicio:
	    btfsc PORTB, 0	;Pregunto RB0=0
	    goto falso1
	    btfsc PORTB, 1	;Pregunto si RB1=0
	    goto falso2
	    bcf LATD, 0		;RB0=0, RB1=0, salida RD0=0
	    goto inicio
falso1:	    btfsc PORTB, 1
	    goto falso3
	    bsf LATD, 0		;RB0=1, RB1=0, salida RD0=1
	    goto inicio
falso2:	    bsf LATD, 0		;RB0=0, RB1=1, salida RD0=1
	    goto inicio
falso3:	    
	    bcf LATD, 0		;RB0=1, RB1=1, salida RD0=0
	    goto inicio
	    end

