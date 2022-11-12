    PROCESSOR 18F4550
    #include "cabecera.inc"

    PSECT resetVec,class=CODE,reloc=2
    resetVec:
	goto configura
	
    PSECT code
configura:
	    bsf TRISB, 0, 0    ;RB4 es una entrada
	    bcf TRISD, 0, 0    ;RD0 es una salida
inicio:
	    btfss PORTB, 0, 0  ;Pregunto si RB4 es uno
	    goto falso	    ;Viene aqui cuando es falso, salta a etiqueta falso
	    bcf LATD, 0, 0    ;Viene aqui cuando es verdadero, pone RD0 a 0
	    goto inicio	    ;Regrese a inicio
falso:	    bsf LATD, 0, 0	    ;RD0 es 1
	    goto inicio
	    
	    END resetVec
	    


