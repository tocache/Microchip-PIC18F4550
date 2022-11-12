    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT VectRST,class=CODE,reloc=2

var_i EQU 0x000    ;El GPR 0x000 va a tener el nombre var_i
    
    ORG 0000H
VectRST:    
	goto configuro
	
    ORG 0020H
configuro:  bcf TRISD, 2, 0
	        
inicio:	    bsf LATD, 2, 0
	    call repeticua
	    bcf LATD, 2, 0
	    call repeticua
	    goto inicio
	    
repeticua:  movlw 255	    ;Será válido colocar 900?
	    movwf var_i, b
otro:	    nop
	    decfsz var_i, 1, 0
	    goto otro
	    return
	    
	    end VectRST




