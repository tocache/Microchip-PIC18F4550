    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto configuro
    
    PSECT code
configuro:
	    bsf TRISB, 1	;RB1 es entrada
	    bcf TRISD, 1	;RD1 es salida
inicio:	    btfss PORTB, 1	;PRegunto RB1=1
	    goto falso		;Cuando es falso, salta a label falso
	    bcf LATD, 1		;RD1=0
	    goto inicio		;Salta a label inicio
falso:	    bsf LATD, 1		;RD1=1
	    goto inicio		;Salta a label inicio
	    
	    end resetVec

