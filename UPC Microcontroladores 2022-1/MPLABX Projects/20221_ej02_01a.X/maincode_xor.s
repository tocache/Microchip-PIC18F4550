    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    bcf TRISD, 0	;Salida del XOR
    bsf TRISB, 1	;Entrada 1 del XOR
    bsf TRISB, 0	;Entrada 0 del XOR
    
loop:
    	    btfsc PORTB, 0	;Pregunto RB0=0
	    goto falso1
	    btfsc PORTB, 1	;Pregunto si RB1=0
	    goto falso2
	    bcf LATD, 0		;RB0=0, RB1=0, salida RD0=0
	    goto loop
falso1:	    btfsc PORTB, 1
	    goto falso3
	    bsf LATD, 0		;RB0=1, RB1=0, salida RD0=1
	    goto loop
falso2:	    bsf LATD, 0		;RB0=0, RB1=1, salida RD0=1
	    goto loop
falso3:	    
	    bcf LATD, 0		;RB0=1, RB1=1, salida RD0=0
	    goto loop
    end principal




