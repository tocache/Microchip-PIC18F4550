    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT menestron, class=CODE, reloc=2, abs
menestron:
    ORG 000100H
mensaje:    DB	15H,79H,00H,6DH,06H,79H,54H,78H,3FH,00H,3FH,50H,6FH
sigue1:	    DB	3EH,38H,38H,3FH,6DH,3FH,00H,5EH,79H,00H,79H,6DH,78H
sigue2:	    DB	3EH,5EH,06H,77H,50H,00H,06H,54H,6FH,79H,54H,06H,79H
sigue3:	    DB	50H,06H,77H
    
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
    movlw HIGH mensaje
    movwf TBLPTRH
    
loop:
;    movlw LOW mensaje
    movlw 1
    movwf TBLPTRL
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
    retfie

low_priority_ISR:
    retfie
    
    end menestron
    


