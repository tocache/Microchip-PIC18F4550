;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs
    
    ORG 00300H
;		    H	  O    L   A
mensaje1:    db     76H, 3FH, 38H, 77H
    ORG 00400H
;		         U     P   C
mensaje2:    db     00H, 3EH, 73H, 39H
        
    ORG 00000H
multiplexacion:	goto configuracion
    
    ORG 00020H
configuracion:
    movlw 0x80
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0xF0
    movwf TRISB		;RB3-RB0 como salidas
    clrf LATB		;Condicion inicial de los habilitadores
    movlw 0x0F
    movwf ADCON1	;Para que RE0 sea entrada digital
    
inicio:
    btfss PORTE, 0	;Pregunta si RE0=1
    goto msg_hola
    goto msg_upc
    
msg_hola:    
    movlw 03H
    movwf TBLPTRH
    clrf TBLPTRL	;Apunta el TBLPTR a 300H
    goto multiplex
    
msg_upc:    
    movlw 04H
    movwf TBLPTRH
    clrf TBLPTRL	;Apunta el TBLPTR a 400H
    goto multiplex

multiplex:    
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
    goto inicio
    end multiplexacion











