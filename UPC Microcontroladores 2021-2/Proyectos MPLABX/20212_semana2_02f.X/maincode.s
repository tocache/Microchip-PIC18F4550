    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT rstVectoron,class=CODE,reloc=2
    ORG 0000H
rstVectoron:	goto configuro
    
    ORG 0020H
configuro:	bcf TRISD, 0, 0	    ;RD0 como salida
inicio:		btfsc PORTB, 0
		goto falso1
		btfsc PORTB, 1
		goto falso2
		bcf LATD, 0
		goto inicio
falso1:		btfsc PORTB, 1	
		goto falso3
		bsf LATD, 0
		goto inicio
falso2:		bsf LATD, 0
		goto inicio
falso3:		bcf LATD, 0
		goto inicio
		
		end rstVectoron


