;FOCA
;
;F = 71H
;O = 3FH
;C = 39H
;A = 77H
    
    PROCESSOR 18F4550
    #include "cabecera.inc"

indicador EQU 000H
 
    PSECT causa_acevichada, class=CODE, reloc=2, abs
causa_acevichada:
    ORG 000000H
    goto configuro
    
    ORG 000008H
    goto Tmr0_ISR
    
    ORG 000500H
mensaje:    db 39H, 77H, 6DH, 77H

    ORG 000600H
mensaje2:    db 77H, 5BH, 3EH, 38H
    
    
    ORG 000020H
configuro:    
    movlw 80H
    movwf TRISD	    ;RD(6:0) como salidas (segmentos)
    movlw 0F0H
    movwf TRISB	    ;RB(3:0) como salidas (habilitadores)
    clrf LATB	    ;Condicion inicial de habilitadores
    clrf TBLPTRU
    movlw HIGH mensaje
    movwf TBLPTRH
    bcf INTCON2, 7  ;activando RBPU
    movlw 83H
    movwf T0CON	    ;Timer0 ON, fosc/4, psc 1:16, modo 16 bits
    movlw 0A0H
    movwf INTCON    ;interrupciones activadas para Timer0
    clrf indicador  ;indicador = 0

inicio:
    movlw LOW mensaje
    movwf TBLPTRL
    call muxxed
    goto inicio
    
muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0
    call nopx4
    bcf LATB, 0
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1
    call nopx4
    bcf LATB, 1
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2
    call nopx4
    bcf LATB, 2
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3
    call nopx4
    bcf LATB, 3
    return

nopx4:
    nop
    nop
    nop
    nop
    return
    
Tmr0_ISR:
    bcf INTCON, 2	;bajamos flasg del Timer0
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		;carga de cuenta inicial en Timer0
    btfss indicador, 0	;me encuentro en mensaje 1?
    goto no_es_cierto	;falso, salta a no_es_cierto
    bcf indicador, 0	;verdad, pone indicador a cero
    movlw 05H
    movwf TBLPTRH
    retfie
no_es_cierto:
    bsf indicador, 0	;pone indicador a uno
    movlw 06H
    movwf TBLPTRH
    retfie
    end causa_acevichada








