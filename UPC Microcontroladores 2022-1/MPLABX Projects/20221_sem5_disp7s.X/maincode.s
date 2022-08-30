;Hecho por Kalun
;Los segmentos estan conectados a RD y los habilitadores en RB
    
    PROCESSOR 18f4550
    #include "cabecera.inc"
    
    PSECT multiplexacion,class=CODE,reloc=2,abs
    
    ORG 00000H
multiplexacion:	goto configuracion
    
    ORG 00020H
configuracion:
    movlw 80H
    movwf TRISD		;RD6-RD0 como salidas
    movlw 0F0H
    movwf TRISB		;RB3-RB0 como salidas
    clrf LATB		;Condicion inicial de los habilitadores
inicio:
    movlw 01110110B	;Letra H
    movwf LATD
    bsf LATB, 0		;Habilito primer dígito
    nop
    bcf LATB, 0		;Deshabilito primer dígito
    movlw 00111111B	;Letra O
    movwf LATD
    bsf LATB, 1
    nop
    bcf LATB, 1
    movlw 00111000B	;Letra L
    movwf LATD
    bsf LATB, 2
    nop
    bcf LATB, 2
    movlw 01110111B	;Letra A
    movwf LATD
    bsf LATB, 3
    nop
    bcf LATB, 3
    goto inicio
    end multiplexacion


