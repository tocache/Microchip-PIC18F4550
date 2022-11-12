;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs
    
    ORG 00300H
;		    H	  O    L   A
mensaje:    db     38H, 3FH, 38H, 77H
   
    ORG 00000H
multiplexacion:	goto configuracion
    
    ORG 00020H
configuracion:
    movlw 0x80
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0xF0
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





