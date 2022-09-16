    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT pollo_a_la_brasa, class=CODE, reloc=2, abs
pollo_a_la_brasa:
    ORG 000000H
    goto configuro

    ORG 000008H
    goto Tmr0_ISR
    
    ORG 000020H
configuro:
    
    
loop:

Tmr0_ISR:
    retfie
    
    end pollo_a_la_brasa
