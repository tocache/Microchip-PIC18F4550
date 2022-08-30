    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0008H
    goto Tmr0_ISR
    ORG 0020H

configuro:	    ;Rutina de configuración inicial
    bcf TRISB, 6    ;RB6 como salida
    movlw 82H
    movwf T0CON	    ;Timer0 FOSC/4 16bits 1:8PSC
    movlw 0A0H
    movwf INTCON    ;Interrupciones habilitadas para Timer0
    movlw 5DH
    movwf TMR0H
    movlw 3DH
    movwf TMR0L	    ;Carga de cuenta inicial en TMR0
    
loop:		    ;Rutina principal
    nop
    goto loop

Tmr0_ISR:	    ;Rutina de interrupción cuando hay desborde en TMR0
    btg LATB, 6	    ;Basculación en RB6
    movlw 5DH
    movwf TMR0H
    movlw 3DH
    movwf TMR0L	    ;Carga de cuenta inicial en TMR0
    bcf INTCON, 2   ;Bajada de bandera de TMR0
    retfie	    ;Retorno
    end principal


