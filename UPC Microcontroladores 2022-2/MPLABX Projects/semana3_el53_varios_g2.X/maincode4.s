    PROCESSOR 18F4550
    #include "cabecera.inc"

temporal EQU 000H
 
    PSECT ciruela, class=CODE, reloc=2, abs
ciruela:
    ORG 000000H
    goto configuracion
    
    ORG 000020H
configuracion:
    bcf INTCON2, 7
    movlw 80H
    movwf TRISD
inicio:
    movf PORTB, w
    andlw 0FH
    movwf temporal
    movlw 0EH
    cpfseq temporal
    goto next1
    movlw 73H
    movwf LATD
    goto inicio
next1:
    movlw 0DH
    cpfseq temporal
    goto next2
    movlw 79H
    movwf LATD
    goto inicio
next2:
    movlw 0BH
    cpfseq temporal
    goto next3
    movlw 50H
    movwf LATD
    goto inicio
next3:
    movlw 07H
    cpfseq temporal
    goto next4
    movlw 3EH
    movwf LATD
    goto inicio
next4:    
    clrf LATD
    goto inicio
    end ciruela


