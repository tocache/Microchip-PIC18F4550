    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT code
    org 0000H
    goto configuro
    
    org 0020H
configuro:
	    clrf TRISB	    ;Todo el RB como salida
	    clrf TRISD	    ;Todo el RD como salida
inicio:
	    movlw 0A5H	    ;Muevo literal 0xA5 a Wreg
	    movwf LATB	    ;Muevo Wreg hacia LATB
	    movlw 5AH	    ;Muevo literal 0x5A a Wreg
	    movwf LATD	    ;Muevo Wreg hacia LATD
	    
	    end 
	    


