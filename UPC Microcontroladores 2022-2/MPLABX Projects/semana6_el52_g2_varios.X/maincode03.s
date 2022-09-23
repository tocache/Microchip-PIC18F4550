    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT menestron, class=CODE, reloc=2, abs

cuenta EQU 000H    

menestron:
    ORG 000100H
si_luz:	DB 00H,00H,00H,00H,76H,77H,6EH,00H,5EH,79H,15H,77H,6DH
sigue1:	DB 06H,77H,5EH,3FH,00H,7CH,50H,06H,38H,38H,3FH,00H,00H
sigue2: DB 00H,00H	

    ORG 000200H
no_luz:	DB 00H,00H,00H,00H,79H,6DH,78H,3FH,6EH,00H,79H,54H,00H
sigue3:	DB 38H,77H,00H,3FH,6DH,39H,3EH,50H,06H,5EH,77H,5EH,00H
sigue4: DB 00H,00H	
    
    
    ORG 000000H
    goto configuro
    
    ORG 000008H
    goto high_priority_ISR
    
    ORG 000018H
    goto low_priority_ISR
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD
    movlw 0E1H
    movwf TRISB
    clrf TBLPTRU
    movlw 80H
    movwf T0CON
    movlw 0A0H
    movwf INTCON
    clrf cuenta
    
loop:
    btfss PORTC, 0
    goto no_hay_luz
    movlw 01H
    movwf TBLPTRH
    goto sale
no_hay_luz:
    movlw 02H
    movwf TBLPTRH 
sale:    
    movff cuenta, TBLPTRL
    call muxxed
    bra loop
    
muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 4	    ;enciendo primer digito
    call nopx8	    ;espero un ratito
    bcf LATB, 4	    ;apago del primer digito
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1	    ;enciendo segundo digito
    call nopx8	    ;espero un ratito
    bcf LATB, 1	    ;apago del segundo digito
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2	    ;enciendo tercer digito
    call nopx8	    ;espero un ratito
    bcf LATB, 2	    ;apago del tercer digito
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3	    ;enciendo cuarto digito
    call nopx8	    ;espero un ratito
    bcf LATB, 3	    ;apago del cuarto digito
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
    bcf INTCON,2
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L
    movlw 24
    cpfseq cuenta
    goto aun_no
    clrf cuenta
    retfie
aun_no:    
    incf cuenta, f
    retfie

low_priority_ISR:
    retfie
    
    end menestron
    








