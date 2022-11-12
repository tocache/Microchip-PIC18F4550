    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT code
    org 0000H
    goto configuro
    
    org 0020H
configuro:  clrf TRISB	    ;Todo RB como salida
	    clrf TRISD	    ;Todo RD como salida
inicio:	    movlw 0A5H	    ;Mueve literal 0A5H hacia Wreg
	    movwf LATB	    ;Mueve Wreg hacia LATB
	    movlw 5AH	    ;Mueve literal 5AH hacia Wreg
	    movwf LATD	    ;Mueve Wreg hacia LATD
	    
	    end


