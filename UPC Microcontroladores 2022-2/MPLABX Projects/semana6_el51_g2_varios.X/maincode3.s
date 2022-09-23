    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT menestron, class=CODE, reloc=2, abs

cuenta EQU 000H		;etiqueta cuenta para GPR 000H
ind1 EQU 001H		;establece basculacion de INT0
ind2 EQU 002H 
    
    ORG 000000H
menestron:
    goto configuro

    ORG 000008H
    goto Int0_ISR
;    goto Tmr0_ISR    

    ORG 000018H
    goto Tmr0_ISR
;    goto Int0_ISR

    ORG 000100H
msg_con_luz: DB 00H, 00H, 00H, 00H, 5EH, 79H, 78H, 79H, 39H, 78H, 3FH, 00H
sigue1: DB 3EH, 54H, 77H, 00H, 38H, 3EH, 5BH, 00H, 00H, 00h
 
    ORG 000200H
msg_sin_luz: DB 00H, 00H, 00H, 00H, 79H, 6DH, 78H, 3FH, 6EH, 00H, 79H, 54H
sigue2: DB 00H, 77H, 73H, 77H, 7DH, 3FH, 54H, 00H, 00H, 00H  

    ORG 000300H
msg_me_des: DB 00H, 00H, 00H, 00H, 15H, 79H, 00H, 5EH, 79H, 6DH, 38H, 3EH
sigue3: DB 15H, 7CH, 50H, 77H, 77H, 77H, 00H, 00H, 00H, 00H     
 
    ORG 000400H
msg_no_veo: DB 00H, 00H, 00H, 00H, 54H, 3FH, 00H, 1CH, 79H, 3FH, 00H, 54H
sigue4: DB 77H, 5EH, 77H, 77H, 77H, 77H, 00H, 00H, 00H, 00H     
 
    ORG 000020H
configuro:    
    movlw 80H
    movwf TRISD	    ;RD(6:0) como salidas
    movlw 0E1H
    movwf TRISB
    clrf LATB
    movlw 81H
    movwf T0CON	    ;Tmr0 ON, fosc/4, psc 1:4, 16bit
    ;zona de configuracion de interrupciones
	bsf RCON, 7
	movlw 0F0H
	movwf INTCON    ;GIEH=1, GIEL=1, TMR0IE=1, INT0IE=1 activando interrupciones
	bcf INTCON2, 2  ;TMR0IP = 0 para que TMR0 este en low priority
	bcf INTCON2, 7	;resistencias internas de pullup en rb activadas
	bcf INTCON2, 6	;INTEDG0 = 0 para falling edge de INT0
    ;termino de zona
    clrf TBLPTRU
    clrf cuenta	    ;inicializo GPR cuenta en cero
    
    
loop:
    btfss PORTC, 0
    goto no_hay_luz
    movlw HIGH msg_con_luz
    movwf TBLPTRH
    goto sale
no_hay_luz:
    movlw HIGH msg_sin_luz
    movwf TBLPTRH
sale:
    movf ind2, w
    addwf TBLPTRH
    movff cuenta, TBLPTRL
    call muxxed
    bra loop
    
muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 4
    call nopx8
    bcf LATB, 4
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1
    call nopx8
    bcf LATB, 1
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2
    call nopx8
    bcf LATB, 2
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3
    call nopx8
    bcf LATB, 3
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
    
Int0_ISR:
    bcf INTCON, 1	;bajamos bandera INT0IF
    btfss ind1, 0
    goto es_cero
es_uno:
    movlw 2
    movwf ind2
    bcf ind1, 0
    retfie
es_cero:
    clrf ind2
    bsf ind1, 0
    retfie
    
Tmr0_ISR:
    bcf INTCON, 2	;Bajamos bandera TMR0IF
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		;cuenta inical 3036 en Tmr0
    movlw 18
    cpfseq cuenta
    goto aun_no
    clrf cuenta
    retfie
aun_no:
    incf cuenta, f
    retfie
    
    end menestron
    








