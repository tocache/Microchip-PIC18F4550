    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT VectRST,class=CODE,reloc=2

;Declaración de nombre en GPR    
var_i EQU 0x000  
var_j EQU 0x001
var_k EQU 0x002 
    
    ORG 0000H
VectRST:    
	goto configuro
	
    ORG 0020H
configuro:  bcf TRISD, 2, 0
	        
inicio:	    bsf LATD, 2, 0
	    call repeticua	;Retardo de 285ms aprox.
	    bcf LATD, 2, 0
	    call repeticua
	    goto inicio
	    
repeticua:   
    movlw 80
    movwf var_i, b
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i, 1, 0
    goto otro1
    return

bucle1:
    movlw 40
    movwf var_j, b
otro2:
    call bucle2		;Salto a subrutina
    decfsz var_j, 1, 0
    goto otro2
    return
    
bucle2:
    movlw 20
    movwf var_k, b
otro3:
    nop			;Se ejecutará 64000 veces
    decfsz var_k, 1, 0
    goto otro3
    return	    
	    
    end VectRST







