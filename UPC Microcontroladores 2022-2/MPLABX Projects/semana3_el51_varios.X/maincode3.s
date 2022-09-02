    PROCESSOR 18F4550
    #include "cabecera.inc"

temporal EQU 000H	;GPR 000H con etiqueta temporal
 
    PSECT camote, class=CODE, reloc=2, abs
camote:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;RBPU=0 res weak pull-up en RB activadas
    movlw 80H
    movwf TRISD		;RD(6:0) como salidas
    
lazo:
    btfsc PORTB, 0
    goto otro1
    movlw 3EH
    movwf LATD
    goto lazo
otro1:
    btfsc PORTB, 1
    goto otro2
    movlw 73H
    movwf LATD
    goto lazo
otro2:
    btfsc PORTB, 2
    goto final
    movlw 39H
    movwf LATD
    goto lazo
final:
    clrf LATD
    goto lazo
    end camote







