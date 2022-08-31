    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    clrf TRISD
    movlw 24H
    movwf ADCON2
    movlw 0EH
    movwf ADCON1
    movlw 01H
    movwf ADCON0
        
loop:
    bsf ADCON0, 1
otro:
    btfsc ADCON0, 1
    goto otro
    movff ADRESH, LATD
    goto loop
        
    end principal


