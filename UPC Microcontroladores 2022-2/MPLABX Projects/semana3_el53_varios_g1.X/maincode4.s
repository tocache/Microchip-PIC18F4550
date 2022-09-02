    PROCESSOR 18F4550
    #include "cabecera.inc"

temp EQU 000H    
    
    PSECT maracuya, class=CODE, reloc=2, abs
maracuya:
    ORG 000000H
    goto configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7	    ;weak pullup en RB encendido
    movlw 80H
    movwf TRISD
    clrf LATD
inicio:
    movf PORTB, w
    andlw 07H
    movwf temp
    movlw 06H
    cpfseq temp
    goto next1
    movlw 3EH
    movwf LATD
    bra inicio
next1:
    movlw 05H
    cpfseq temp
    goto next2
    movlw 73H
    movwf LATD
    bra inicio
next2:
    movlw 03H
    cpfseq temp
    goto next3
    movlw 39H
    movwf LATD
    bra inicio
next3:
    clrf LATD
    bra inicio
    end maracuya
    
    

