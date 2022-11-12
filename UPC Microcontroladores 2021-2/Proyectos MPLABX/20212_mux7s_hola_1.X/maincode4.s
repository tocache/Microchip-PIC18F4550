;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs

cuenta EQU 000H
 
    ORG 00300H		;Zona donde se alojaran las letras del mensaje
mensaje:    db     00H, 00H, 00H, 00H, 76H, 3FH, 38H, 77H, 00H, 3EH, 73H, 39H, 00H, 00H, 00H
    
    ORG 00000H		;Vector de reset
multiplexacion:	goto configuracion
    
    ORG 00008H		;Vector de interrupcion
vector_hp:	goto TMR0_ISR
    
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
    movwf TBLPTRL	;TBLPTR apunta a 300H
    movlw 81H
    movwf T0CON		;Configuracion del TMR0: Fosc/4 16bit PSC1:4
    movlw 0A0H
    movwf INTCON	;Configuracion de Ints: Desborde de TMR0
    clrf cuenta
    
inicio:
    movf cuenta, 0
    addwf TBLPTRL
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
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 3
    nop
    bcf LATB, 3
    clrf TBLPTRL
    goto inicio
    
TMR0_ISR:
    movlw 11
    cpfseq cuenta
    goto incremento
    clrf cuenta
    goto otro
incremento:    
    incf cuenta, 1
otro:
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		 ;Carga de cuenta inicial para TMR0
    bcf INTCON, 2
    retfie
    end multiplexacion








