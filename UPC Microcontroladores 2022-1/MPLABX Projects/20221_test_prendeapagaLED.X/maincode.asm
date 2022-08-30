    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    bsf OSCCON, 6, 0
    bsf OSCCON, 5, 0
    bcf OSCCON, 4, 0   ;INTOSC funcionando a 4MHz
    bcf TRISD, 0, 0    ;RD0 como salida
    movlw 81H
    movwf T0CON, 0	    ;Timer0 activado, 16bit, PSC1:4, FOSC/4
    
loop:
    btfss INTCON, 2, 0
    goto loop
    bcf INTCON, 2, 0
    btg LATD, 0, 0
    goto loop
    
    end principal


