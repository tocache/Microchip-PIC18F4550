;FOCA
;
;F = 71H
;O = 3FH
;C = 39H
;A = 77H
    
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT causa_acevichada, class=CODE, reloc=2, abs
causa_acevichada:
    ORG 000000H
    goto configuro
    
    ORG 000008H
    goto Tmr0_ISR
    
    ORG 000020H
configuro:    
    movlw 80H
    movwf TRISD	    ;RD(6:0) como salidas (segmentos)
    movlw 0F0H
    movwf TRISB	    ;RB(3:0) como salidas (habilitadores)
    clrf LATB	    ;Condicion inicial de habilitadores
inicio:
    movlw 71H
    movwf LATD
    bsf LATB, 0
    call nopx4
    bcf LATB, 0
    movlw 3FH
    movwf LATD
    bsf LATB, 1
    call nopx4
    bcf LATB, 1
    movlw 39H
    movwf LATD
    bsf LATB, 2
    call nopx4
    bcf LATB, 2
    movlw 77H
    movwf LATD
    bsf LATB, 3
    call nopx4
    bcf LATB, 3
    goto inicio

nopx4:
    nop
    nop
    nop
    nop
    return
    
Tmr0_ISR:
    retfie
    
    end causa_acevichada