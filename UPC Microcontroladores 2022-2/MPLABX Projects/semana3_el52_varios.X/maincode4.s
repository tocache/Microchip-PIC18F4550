    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT cebolla, class=CODE, reloc=2, abs
cebolla:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD		;RD(6:0) como salidas
    bcf INTCON2, 7	;Activamos weak pullup de RB
inicio:
    btfsc PORTB, 0
    goto siguiente1
    movlw 3EH
    movwf LATD
    goto inicio
siguiente1:
    btfsc PORTB, 1
    goto siguiente2
    movlw 73H
    movwf LATD
    goto inicio
siguiente2:
    btfsc PORTB, 2
    goto siguiente3
    movlw 39H
    movwf LATD
    goto inicio
siguiente3:
    clrf LATD
    goto inicio
    end cebolla

