    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H
    
configuro:
    clrf TRISD	    ;Puerto D como salida
    
loop:
    comf PORTB, 0   ;Leo RB, aplico complemento y almaceno en WReg
    movwf LATD
    goto loop
    end principal


