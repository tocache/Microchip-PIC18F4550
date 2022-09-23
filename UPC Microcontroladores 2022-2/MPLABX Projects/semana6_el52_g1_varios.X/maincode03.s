    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT tallarines_verdes_con_bistec, class=CODE, reloc=2, abs

tallarines_verdes_con_bistec:

cuenta EQU 000H	    ;etiqueta cuenta para GPR 000H    
    
    ORG 000100H
si_hay_luz: DB	00H,00H,00H,00H,76H,77H,6EH,00H,5EH,79H,15H,77H
sigue1: DB	6DH,06H,77H,5EH,3FH,00H,7CH,50H,06H,38H,38H,3FH
sigue2: DB	00H,00H,00H
 
    ORG 000200H
no_hay_luz: DB	00H,00H,00H,00H,79H,6DH,78H,3FH,6EH,00H,79H,54H
sigue3: DB	00H,38H,77H,00H,3FH,6DH,39H,3EH,50H,06H,5EH,77H
sigue4: DB	5EH,00H,00H,00H
   
    ORG 000000H
    goto configuro
    
    ORG 000008H
    goto high_priority_ISR
    
    ORG 000018H
    goto low_priority_ISR
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD		;RD(6:0) como salidas
    movlw 0E1H
    movwf TRISB		;RB(4:1) como salidas
    movlw 81H
    movwf T0CON		;TMR0 ON, fosc/4, 16bits, psc 1:4
    movlw 0A0H
    movwf INTCON	;GIE=1, TMR0IE=1 (TMR0 interrupt enabled)
    clrf TBLPTRU
    clrf cuenta

loop:
    btfss PORTC, 0
    goto apagado
    movlw 01H
    movwf TBLPTRH
    goto sale
apagado:
    movlw 02H
    movwf TBLPTRH
sale:    
    movff cuenta, TBLPTRL
    call muxxed
    bra loop
    
muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 4		;enciendo D1
    call nopx8		;espero un ratito
    bcf LATB, 4		;apago D1
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1		;enciendo D2
    call nopx8		;espero un ratito
    bcf LATB, 1		;apago D2
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2		;enciendo D3
    call nopx8		;espero un ratito
    bcf LATB, 2		;apago D3
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3		;enciendo D4
    call nopx8		;espero un ratito
    bcf LATB, 3		;apago D4
    return
    
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
    
high_priority_ISR:
    bcf INTCON, 2	;TMR0IF=0
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		;carga de cta inicial 3036 en TMR0
    movlw 23
    cpfseq cuenta
    goto no_es_igual
    clrf cuenta
    retfie
no_es_igual:    
    incf cuenta, f
    retfie
    
    
    
low_priority_ISR:
    retfie
    
    end tallarines_verdes_con_bistec
    
    
    








