    PROCESSOR 18F4550
    #include "cabecera.inc"

temp EQU 000H    
    
    PSECT bebitofiufiu, class=CODE, reloc=2, abs
bebitofiufiu:
    ORG 000000H
    bra configuro
    
    ORG 000020H
configuro:
    movlw 0FH
    movwf TRISB
    movlw 80H
    movwf TRISD
    movlw 0F0H
    movwf LATB
inicio:
    movf PORTB, w
    andlw 03H
    movwf temp
    movlw 0
    cpfseq temp
    goto no1
    call vis_msg1
    bra inicio
no1:
    movlw 1
    cpfseq temp
    goto no2
    call vis_msg2
    bra inicio
no2:
    movlw 2
    cpfseq temp
    goto no3
    call vis_msg3
    bra inicio
no3:call vis_msg4
    bra inicio
    
vis_msg1:
    movlw 73H
    movwf LATD
    bcf LATB, 7
    nop
    nop
    nop
    nop
    bsf LATB, 7
    movlw 79H
    movwf LATD
    bcf LATB, 6
    nop
    nop
    nop
    nop
    bsf LATB, 6
    movlw 50H
    movwf LATD
    bcf LATB, 5
    nop
    nop
    nop
    nop
    bsf LATB, 5
    movlw 3EH
    movwf LATD
    bcf LATB, 4
    nop
    nop
    nop
    nop
    bsf LATB, 4
    return

vis_msg2:
    movlw 6DH
    movwf LATD
    bcf LATB, 7
    nop
    nop
    nop
    nop
    bsf LATB, 7
    movlw 79H
    movwf LATD
    bcf LATB, 6
    nop
    nop
    nop
    nop
    bsf LATB, 6
    movlw 5EH
    movwf LATD
    bcf LATB, 5
    nop
    nop
    nop
    nop
    bsf LATB, 5
    movlw 79H
    movwf LATD
    bcf LATB, 4
    nop
    nop
    nop
    nop
    bsf LATB, 4
    return

vis_msg3:
    movlw 5BH
    movwf LATD
    bcf LATB, 7
    nop
    nop
    nop
    nop
    bsf LATB, 7
    movlw 3FH
    movwf LATD
    bcf LATB, 6
    nop
    nop
    nop
    nop
    bsf LATB, 6
    movlw 5BH
    movwf LATD
    bcf LATB, 5
    nop
    nop
    nop
    nop
    bsf LATB, 5
    movlw 5BH
    movwf LATD
    bcf LATB, 4
    nop
    nop
    nop
    nop
    bsf LATB, 4
    return
    
vis_msg4:
    movlw 38H
    movwf LATD
    bcf LATB, 7
    nop
    nop
    nop
    nop
    bsf LATB, 7
    movlw 30H
    movwf LATD
    bcf LATB, 6
    nop
    nop
    nop
    nop
    bsf LATB, 6
    movlw 15H
    movwf LATD
    bcf LATB, 5
    nop
    nop
    nop
    nop
    bsf LATB, 5
    movlw 77H
    movwf LATD
    bcf LATB, 4
    nop
    nop
    nop
    nop
    bsf LATB, 4
    return    
    
    end bebitofiufiu
    
    
    

