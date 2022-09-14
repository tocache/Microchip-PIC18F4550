    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT piononodevitrina, class=CODE, reloc=2, abs
piononodevitrina:
    ORG 000000H
    bra configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0
    bcf TRISE, 0
    movlw 0FH
    movwf ADCON1
    bsf LATC, 0
bucle:
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
    bra bucle
    end piononodevitrina
    


