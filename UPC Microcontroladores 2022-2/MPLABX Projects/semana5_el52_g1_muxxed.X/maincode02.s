    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT milanesa_con_papas, class=CODE, reloc=2, abs
milanesa_con_papas:
    ORG 000000H
    goto configuro

    ORG 000008H
    goto Tmr0_ISR

    ORG 000800H
mensaje:    db	73H, 79H, 50H, 3EH    
    
    ORG 000020H
configuro:    
    movlw 80H
    movwf TRISD		;RD(6:0) como salidas
    movlw 0F0H
    movwf TRISB		;RB(3:0) como salidas
    clrf LATB		;Condicion inicial de RB
    clrf TBLPTRU
    movlw HIGH mensaje
    movwf TBLPTRH
    movlw 83H
    movwf T0CON		;Timer0 ON, 16bit, fosc/4, psc 1:16
    movlw 0A0H
    movwf INTCON	;interrupciones habilitadas para Timer0
    bcf TRISB, 5	;RB5 como salida
    
inicio:
    movlw LOW mensaje
    movwf TBLPTRL	;TBLPTR apuntando a 800H
    call muxxed
    goto inicio

muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0		;enciendo D1
    call nopx8		;espero un ratito
    bcf LATB, 0		;apago D1
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
    
Tmr0_ISR:
    bcf INTCON, 2	;bajamos bandera TMR0IF
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		;Cargamos cuenta inicial 3036 en Timer0
    btg LATB, 5
    retfie
    
    end milanesa_con_papas




