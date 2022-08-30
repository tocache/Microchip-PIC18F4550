;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs
    
    ORG 00300H
;		     C	  O    S   A
mensaje1:    db     39H, 3FH, 6DH, 77H
    ORG 00400H
;		     b	  O    n   i
mensaje2:    db     7CH, 3FH, 54H, 04H
    ORG 00500H
;		     t	  a         
mensaje3:    db     78H, 77H, 00H, 00H
   
    ORG 00000H
multiplexacion:	goto configuracion
    
    ORG 00020H
configuracion:
    movlw 80H
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0F0H
    movwf TRISB		;RB3-RB0 como salidas
    clrf LATB		;Condicion inicial de los habilitadores
    movlw LOW mensaje1
    movwf TBLPTRL	;TBLPTR apuntando a mensaje (300H) 
    movlw HIGH mensaje1
    movwf TBLPTRH    
    movlw 82H
    movwf T0CON		;Timer0 ON, 16bit, 1:8PSC, FOSC/4
    
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
    btfss INTCON, 2	;Pregunto si se desbordó Timer0
    goto inicio
    bcf INTCON, 2
    movlw 05H
    cpfseq TBLPTRH
    goto noes
    movlw 03H
    movwf TBLPTRH
    goto inicio
noes:
    incf TBLPTRH, 1
    goto inicio
    
    end multiplexacion













