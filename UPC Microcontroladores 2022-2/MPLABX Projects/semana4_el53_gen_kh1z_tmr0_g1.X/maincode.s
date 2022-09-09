    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT caramelodechocolate, class=CODE, reloc=2, abs
caramelodechocolate:
    ORG 000000H
    bra configuro
    
    ORG 000020H
configuro:
    bcf TRISE, 0
    bcf TRISC, 0
    movlw 0FH
    movwf ADCON1
    bsf LATC, 0
inicio:
    bsf LATE, 0
    movlw 0C8H
    movwf T0CON
    movlw 56
    movwf TMR0L
    btfss INTCON, 2
    bra $-2
    bcf INTCON, 2
    bcf LATE, 0
    movlw 0C1H
    movwf T0CON
    movlw 56
    movwf TMR0L
    btfss INTCON, 2
    bra $-2
    bcf INTCON, 2
    bra inicio
    end caramelodechocolate
    


