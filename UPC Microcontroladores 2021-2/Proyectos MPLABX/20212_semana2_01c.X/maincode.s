    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT resVect,class=CODE,reloc=2
    ORG 0000H
resVect:
    goto configuro
    
    ORG 0020H
configuro:    
    clrf TRISB, 0	    ;Puerto B todos como salida
    clrf TRISD, 0	    ;Puerto D todos como salida
inicio:
    movlw 5AH
    movwf LATD, 0
    movlw 0A5H
    movwf LATB, 0
    
    end resVect
    


