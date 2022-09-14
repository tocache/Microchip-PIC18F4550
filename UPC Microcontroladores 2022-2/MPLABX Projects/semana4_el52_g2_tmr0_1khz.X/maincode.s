    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT cafecito, class=CODE, reloc=2, abs
cafecito:
    ORG 000000H
    bra configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0    ;RC0 como salida
    bcf TRISE, 0    ;RE0 como salida
    movlw 0FH
    movwf ADCON1    ;Puertos ANx como digitales
    movlw 0C0H
    movwf T0CON	    ;Timer0 ON, 8bit, fosc/4, PSC 1:2
    bsf LATC, 0	    ;RC0=1 encendemos el LED en RC0
inicio:
    movlw 6
    movwf TMR0L	    ;carga de cuenta inicial a Timer0
    btfss INTCON, 2 ;Pregunto si TMR0IF=1 o si se desbordo Timer0
    bra $-2	    ;falso, vuelve a preguntar
    bcf INTCON, 2   ;verdad, bajo la bandera
    btg LATE, 0	    ;basculo salida RC0
    bra inicio	    ;retorno a inicio


