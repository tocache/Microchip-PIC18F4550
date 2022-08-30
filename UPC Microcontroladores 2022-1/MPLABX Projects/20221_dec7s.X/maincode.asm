    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    ;clrf TRISD, 0
    movlw 80H
    movwf TRISD			;RD6 al RD0 como salidas
    
loop:
    movlw 01100110B
    movwf LATD, 0		;Visualizar 4 en el display de 7S
    end principal


