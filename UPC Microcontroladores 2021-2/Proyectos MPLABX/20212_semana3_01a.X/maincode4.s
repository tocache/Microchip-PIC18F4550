;Programa para visualizar "UPC" en el display de 7 segmentos
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT rstVect,class=CODE,reloc=2

;Declaración de nombre en GPR    
var_i EQU 0x000  
var_j EQU 0x001
var_k EQU 0x002 
 
    ORG 0000H
rstVect:    goto configuracion
    
    ORG 0020H
configuracion:	movlw 80H
		movwf TRISD	;RD6:RD0 como salidas
inicio:		movlw 00111110B	;letra U en el disp 7 segm
		movwf LATD
		call repeticua
		movlw 01110011B	;letra P en el disp 7 segm
		movwf LATD
		call repeticua		
		movlw 00111001B	;letra C en el disp 7 segm
		movwf LATD
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
    movlw 80
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
    nop			
    decfsz var_k, 1, 0
    goto otro3
    return			

    end rstVect





