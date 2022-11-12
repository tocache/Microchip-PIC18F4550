    PROCESSOR 18F4550
    #include "cabecera.inc"

    PSECT muynuevo,class=CODE,reloc=2
    ORG 0000H
muynuevo:
    goto configuro
    ORG 0020H
configuro:
	    bcf TRISD, 0, 0    ;RD0 como salida

inicio:     btfsc PORTB, 0, 0	;Pregunto RB0=0
	    goto falso1		;Salto a falso1 cuando es falso
	    btfsc PORTB, 1, 0	;Pregunto RB1=0
	    goto falso2		;Salto a falso2 cuando es falso
	    bcf LATD, 0, 0	;RB0=0 RB1=0 por tanto RD0=0
	    goto inicio		;Salto a inicio
falso1:	    btfsc PORTB, 1, 0	;Pregunto RB1=0
	    goto falso3		;Salto a falso3 cuando es falso
	    bsf LATD, 0, 0	;RB0=1 RB1=0 por tanto RD0=1
	    goto inicio		;Salto a inicio
falso2:	    bsf LATD, 0, 0	;RB0=0 RB1=1 por tanto RD0=1
	    goto inicio		;Salto a inicio
falso3:	    bcf LATD, 0, 0	;RB0=1 RB1=1 por tanto RD0=0
	    goto inicio		;Salto a inicio
  
	    end muynuevo


