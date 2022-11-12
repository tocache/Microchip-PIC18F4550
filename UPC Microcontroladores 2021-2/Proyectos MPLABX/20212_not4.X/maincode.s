    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto configuro
    
    PSECT code
configuro:
    bsf TRISB, 2, 0	;RB2 como entrada
    bcf TRISD, 2, 0	;RD2 como salida
inicio:
    btfss PORTB, 2, 0	;Pregunto si RB2=1
    goto falso		;Viene aqui cuando falso, salta a label falso
    bcf LATD, 2, 0		;Viene aqui cuando verdad, RD2=0
    goto inicio		;Salta a label inicio
falso:
    bsf LATD, 2, 0		;RD1=1
    goto inicio		;Salta a label inicio
    
    END resetVect

