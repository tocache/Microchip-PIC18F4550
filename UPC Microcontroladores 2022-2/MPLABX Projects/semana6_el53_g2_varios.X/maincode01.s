    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT tallarines_rojos_con_milanesa, class=CODE, reloc=2, abs
tallarines_rojos_con_milanesa:

    ORG 000100H
mensaje:    DB	54H,79H,39H,79H,6DH,06H,78H,3FH,00H,79H,6DH
sigue1:	    DB	78H,3EH,5EH,06H,77H,50H,00H,15H,77H,6DH,00H
sigue2:	    DB	73H,77H,50H,77H,00H,38H,3FH,6DH,00H,73H,77H
sigue3:	    DB	50H,39H,06H,77H,38H,79H,6DH    
    
    ORG 000000H
    bra configuro
    
    ORG 000008H
    bra high_priority_ISR
    
    ORG 000018H
    bra low_priority_ISR

configuro:
    movlw 80H
    movwf TRISD
    movlw 0E1H
    movwf TRISB
    clrf TBLPTRU
    movlw 01H
    movwf TBLPTRH
    
rut_principal:
    clrf TBLPTRL
    call muxxed
    bra rut_principal
    
muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 4		;habilito D1
    call nopx12		;retardito
    bcf LATB, 4		;deshabilito D1
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 1		;habilito D2
    call nopx12		;retardito
    bcf LATB, 1		;deshabilito D2
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 2		;habilito D3
    call nopx12		;retardito
    bcf LATB, 2		;deshabilito D3
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 3		;habilito D4
    call nopx12		;retardito
    bcf LATB, 3		;deshabilito D4
    return
    
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

high_priority_ISR:
    retfie
    
low_priority_ISR:
    retfie
    
    end tallarines_rojos_con_milanesa
