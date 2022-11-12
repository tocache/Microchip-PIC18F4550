;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs

    ;Declaración de nombre en GPR    
var_i EQU 0x000  
var_j EQU 0x001
var_k EQU 0x002 
 
    ORG 00000H
multiplexacion:	goto configuracion
    
    ORG 00020H
configuracion:
    movlw 0x80
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0xF0
    movwf TRISB		;RB3-RB0 como salidas
    clrf LATB		;Condicion inicial de los habilitadores
inicio:
    movlw 01110110B	;Letra H
    movwf LATD
    bsf LATB, 0
    call repeticua
    bcf LATB, 0
    movlw 00111111B	;Letra O
    movwf LATD
    bsf LATB, 1
    call repeticua
    bcf LATB, 1
    movlw 00111000B	;Letra L
    movwf LATD
    bsf LATB, 2
    call repeticua
    bcf LATB, 2
    movlw 01110111B	;Letra A
    movwf LATD
    bsf LATB, 3
    call repeticua
    bcf LATB, 3
    goto inicio
    
repeticua:   
    movlw 20
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
    nop			;Se ejecutará 64000 veces
    decfsz var_k, 1, 0
    goto otro3
    return	     
    end multiplexacion