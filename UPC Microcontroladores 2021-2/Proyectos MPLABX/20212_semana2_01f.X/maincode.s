    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT rstVect,class=CODE,reloc=2
    ORG 0000H
rstVect:
	    goto configuro
	    
    ORG 0020H
configuro:  clrf TRISB, 0
	    clrf TRISD, 0
inicio:	    movlw 5AH
	    movwf LATD, 0
	    movlw 0A5H
	    movwf LATB, 0
	    
	    end rstVect
	    


