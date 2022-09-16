    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT asado_con_pure, class=CODE, reloc=2, abs
asado_con_pure:
    ORG 000000H
    goto configuro
    
    ORG 000008H
    goto Tmr0_ISR
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD	    ;RD(6:0) como salidas
    movlw 0D0H
    movwf TRISB	    ;RB(5, 3:0) como salidas
    clrf LATB	    ;condicion inicial de RB
    movlw 83H
    movwf T0CON	    ;Timer0 ON, fosc/4, modo 16bit, psc 1:16
    movlw 0A0H
    movwf INTCON    ;GIE=1, TMR0IE=1. Activamos int para Timer0
    
inicio:
    movlw 77H
    movwf LATD	    ;mando A a RD
    bsf LATB, 0	    ;enciendo primer digito
    call nopx8	    ;espero un ratito
    bcf LATB, 0	    ;apago del primer digito
    movlw 5BH
    movwf LATD	    ;mando Z a RD
    bsf LATB, 1	    ;enciendo segundo digito
    call nopx8	    ;espero un ratito
    bcf LATB, 1	    ;apago del segundo digito
    movlw 3EH
    movwf LATD	    ;mando U a RD
    bsf LATB, 2	    ;enciendo tercer digito
    call nopx8	    ;espero un ratito
    bcf LATB, 2	    ;apago del tercer digito
    movlw 38H
    movwf LATD	    ;mando L a RD
    bsf LATB, 3	    ;enciendo cuarto digito
    call nopx8	    ;espero un ratito
    bcf LATB, 3	    ;apago del cuarto digito
    goto inicio
    
nopx8:
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
    bcf INTCON, 2	;Bajamos bandera TMR0IF
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		;Cargamos cuenta inicial 3036 a TMR0
    btg LATB, 5		;Basculamos RB5 donde esta el LED
    retfie
    
    end asado_con_pure





