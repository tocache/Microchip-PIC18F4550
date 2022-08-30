;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs

var_i EQU 000H
var_j EQU 001H
var_k EQU 002H
 
    ORG 00300H
;		     S   A    C     O
mensaje:    db     6DH, 77H, 39H, 3FH 
   
    ORG 00000H
multiplexacion:	goto configuracion
    
    ORG 00020H
configuracion:
    movlw 80H
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0F0H
    movwf TRISB		;RB3-RB0 como salidas
    clrf LATB		;Condicion inicial de los habilitadores
    movlw HIGH mensaje
    movwf TBLPTRH
    movlw LOW mensaje
    movwf TBLPTRL	;TBLPTR apuntando a mensaje (300H)
    
inicio:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0
    nop
    bcf LATB, 0
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1
    nop
    bcf LATB, 1
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2
    nop
    bcf LATB, 2
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3
    nop
    bcf LATB, 3
    clrf TBLPTRL
    goto inicio

    end multiplexacion








