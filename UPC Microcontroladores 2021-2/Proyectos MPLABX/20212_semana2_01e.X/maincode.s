    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT resetVector,class=CODE,reloc=2
    ORG 0000H
resetVector:
		goto configuro
		
    ORG 00020H
configuro:	clrf TRISB	;Coloca todos los bits de TRISB en cero
		clrf TRISD	;Coloca todos los bits de TRISD en cero
inicio:		movlw 5AH
		movwf LATD
		movlw 0A5H
		movwf LATB
		
		end resetVector


