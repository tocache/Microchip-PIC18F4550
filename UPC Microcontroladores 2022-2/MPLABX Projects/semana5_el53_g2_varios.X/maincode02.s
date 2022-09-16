    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT filete_con_ensalada, class=CODE, reloc=2, abs
filete_con_ensalada:
    ORG 000000H
    goto configuro
    
    ORG 000008H
    goto Tmr0_ISR
    
    ORG 000020H
configuro:
    movlw 0D0H
    movwf TRISB		;RB5, RB3 al RB0 como salidas
    movlw 80H
    movwf TRISD		;RD6 al RD0 como salidas
    bcf INTCON2, 7	;RBPU habilitadas
    movlw 83H
    movwf T0CON		;TMR0 ON, fosc/4, modo 16bit, psc 1:16
    movlw 0A0H
    movwf INTCON	;GIE=1, TMR0IE=1 activamos interr de TMR0
    clrf LATB		;condicion inicial de RB
    
loop:			;rutina principal
    movlw 71H
    movwf LATD		;letra F
    bsf LATB, 0		;habilito D1
    call nopx12		;retardito
    bcf LATB, 0		;deshabilito D1
    movlw 06H
    movwf LATD		;letra I
    bsf LATB, 1		;habilito D2
    call nopx12		;retardito
    bcf LATB, 1		;deshabilito D2
    movlw 1EH
    movwf LATD		;letra J
    bsf LATB, 2		;habilito D3
    call nopx12		;retardito
    bcf LATB, 2		;deshabilito D3
    movlw 77H
    movwf LATD		;letra A
    bsf LATB, 3		;habilito D4
    call nopx12		;retardito
    bcf LATB, 3		;deshabilito D4
    bra loop

nopx12:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    return
    
Tmr0_ISR:
    bcf INTCON, 2	;bajamos bandera de desborde de TMR0 (TMR0IF=0)
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		;carga de cuenta inicial 3036 en TMR0
    btg LATB, 5		;basculamos RB5 donde esta el LED
    retfie
    
    end filete_con_ensalada
    





