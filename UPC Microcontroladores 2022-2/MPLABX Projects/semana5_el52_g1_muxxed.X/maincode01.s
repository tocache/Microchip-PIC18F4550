    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT milanesa_con_papas, class=CODE, reloc=2, abs
milanesa_con_papas:
    ORG 000000H
    goto configuro

    ORG 000008H
    goto Tmr0_ISR
    
    ORG 000020H
configuro:    
    movlw 80H
    movwf TRISD		;RD(6:0) como salidas
    movlw 0F0H
    movwf TRISB		;RB(3:0) como salidas
    clrf LATB		;Condicion inicial de RB
    
inicio:
    movlw 73H
    movwf LATD		;LATD <- P
    bsf LATB, 0		;enciendo D1
    call nopx8		;espero un ratito
    bcf LATB, 0		;apago D1
    movlw 79H
    movwf LATD		;LATD <- e
    bsf LATB, 1		;enciendo D2
    call nopx8		;espero un ratito
    bcf LATB, 1		;apago D2
    movlw 50H
    movwf LATD		;LATD <- r
    bsf LATB, 2		;enciendo D3
    call nopx8		;espero un ratito
    bcf LATB, 2		;apago D3
    movlw 3EH
    movwf LATD		;LATD <- u
    bsf LATB, 3		;enciendo D4
    call nopx8		;espero un ratito
    bcf LATB, 3		;apago D4
    goto inicio

nopx8:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return
    
Tmr0_ISR:
    retfie
    
    end milanesa_con_papas

