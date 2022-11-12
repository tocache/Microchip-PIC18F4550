    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT resetVector,class=CODE,reloc=2
    ORG 0000H
resetVector:
    goto configuro
    
    ORG 0020H
configuro:  clrf TRISB, 0
	    clrf TRISD, 0
inicio:	    movlw 0A5H
	    movwf LATD, 0
	    movlw 5AH
	    movwf LATB, 0
	    end resetVector
    
    


