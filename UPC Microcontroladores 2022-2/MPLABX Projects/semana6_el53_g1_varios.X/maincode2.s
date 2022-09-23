    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT empanada_de_aji_de_gallina, class=CODE, reloc=2, abs
empanada_de_aji_de_gallina:
    
cuenta EQU 000H    
    
    ORG 000100H
si_luz:	DB 00H,00H,00H,00H,76H,77H,6EH,00H,73H,3FH,39H,77H,00H,38H,3EH,5BH,00H,00H,00H,00H

    ORG 000200H
no_luz: DB 00H,00H,00H,00H,76H,77H,6EH,00H,15H,3EH,39H,76H,77H,00H,38H,3EH,5BH,00H,00H,00H
    
    ORG 000000H
    bra configuro
    
    ORG 000008H
    bra high_priority_ISR
    
    ORG 000018H
    bra low_priority_ISR
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD
    movlw 0E1H
    movwf TRISB
    movlw 81H
    movwf T0CON
    movlw 0A0H
    movwf INTCON
    clrf TBLPTRU
    clrf cuenta
    
principal:
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
    bra principal

muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0		;habilito primer digito del display
    call nopx16		;espero un ratito
    bcf LATB, 0		;deshabilito primer digito del display
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1		;habilito segundo digito del display
    call nopx16		;espero un ratito
    bcf LATB, 1		;deshabilito segundo digito del display
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2		;habilito tercer digito del display
    call nopx16		;espero un ratito
    bcf LATB, 2		;deshabilito tercer digito del display
    TBLRD*
    movff TABLAT, LATD
    bsf LATB, 3		;habilito cuarto digito del display
    call nopx16		;espero un ratito
    bcf LATB, 3		;deshabilito cuarto digito del display
    return		;retorno de subrutina

nopx16:
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
    nop
    nop
    nop
    nop
    return    
    
high_priority_ISR:
    bcf INTCON, 2
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L
    movlw 16
    cpfseq cuenta
    bra no_es
    clrf cuenta
    retfie
no_es:    
    incf cuenta, f
    retfie

low_priority_ISR:    
    retfie
    
    end empanada_de_aji_de_gallina

    


