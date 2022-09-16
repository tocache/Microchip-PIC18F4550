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
    movlw 0F0H
    movwf TRISB	    ;RB(3:0) como salidas
    clrf LATB	    ;condicion inicial de RB
    
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
    retfie
    
    end asado_con_pure


