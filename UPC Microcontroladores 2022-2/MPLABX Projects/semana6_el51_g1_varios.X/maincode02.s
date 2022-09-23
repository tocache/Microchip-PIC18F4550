    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT salchipapa, class=CODE, reloc=2, abs

cuenta EQU 000H	    ;declaracion de etiqueta a GPR 000H
indicador1 EQU 001H  ;declaracion de etiqueta a GPR 001H
indicador2 EQU 002H  ;declaracion de etiqueta a GPR 002H 
 
salchipapa:    
    ORG 000000H
    goto configuro
    
    ORG 000008H		;vector de alta prioridad de interrupcion
    goto Int0_ISR

    ORG 000018H		;vector de baja prioridad de interrupcion
    goto Tmr0_ISR
    
    ORG 000100H
msg_de_dia: DB 00H, 00H, 00H, 00H, 5EH, 79H, 00H, 5EH, 06H, 77H, 00H, 00H, 00H, 00H, 00H, 00H
 
    ORG 000200H
msg_de_noche: DB  00H, 00H, 00H, 00H, 5EH, 79H, 00H, 54H, 3FH, 39H, 76H, 79H, 00H, 00H, 00H, 00H

    ORG 000300H
msg_claro: DB 00H, 00H, 00H, 00H, 79H, 6DH, 78H, 77H, 00H, 39H, 38H, 77H, 50H, 3FH, 00H, 00H, 00H, 00H

    ORG 000400H
msg_oscuro: DB 00H, 00H, 00H, 00H, 79H, 6DH, 78H, 77H, 00H, 3FH, 6DH, 39H, 3EH, 50H, 3FH, 00H, 00H, 00H

    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD		    ;RD(6:0) como salidas
    movlw 0E1H
    movwf TRISB		    ;RB(3:0) como salidas
    clrf TBLPTRU
    movlw HIGH msg_de_dia
    movwf TBLPTRH
    movlw HIGH msg_de_dia
    movwf TBLPTRL	    ;TBLPTR apuntando a msg_de_dia
    movlw 81H
    movwf T0CON		    ;Timer0 ON, 16bit, fosc/4, psc 1:16
    movlw 0F0H
    movwf INTCON	    ;Interrupciones habilitadas para Timer0 y para INT0
    bcf INTCON2, 7	    ;Activar las weak pull up del RB
    bcf INTCON2, 6	    ;falling edge para INT0
    bsf RCON, 7		    ;habilito prioridad en las interrupciones
    bcf INTCON2, 2	    ;mando Timer0 a la baja prioridad
    clrf cuenta		    ;cuenta empezando en cero
    clrf indicador1	    ;indicador1 empezando en cero
    clrf indicador2	    ;indicador2 empezando en cero
loop:
    btfss PORTC, 0	    ;Pregunto si es de dia o de noche
    goto de_noche
de_dia:
    movlw 01H
    movwf TBLPTRH
    goto sale
de_noche:    
    movlw 02H
    movwf TBLPTRH
    goto sale
sale:    
    call muxxed
    bra loop

muxxed:			    ;subrutina de multiplexacion
    movff cuenta, TBLPTRL
    movf indicador2, w
    addwf TBLPTRH
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
    
Tmr0_ISR:
    bcf INTCON, 2	    ;Bajamos la bandera TMR0IF
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L		    ;Cargamos cuenta inicial 3036 a TMR0
    movlw 11
    cpfseq cuenta
    goto aun_no
    clrf cuenta
    retfie
aun_no:
    incf cuenta, f
    retfie
    
Int0_ISR:
    bcf INTCON, 1	    ;bajamos la bandera INT0IF
    btfss indicador1, 0	    ;pregunto si estado es uno de indicador1
    goto no_es_cierto
    movlw 2
    movwf indicador2
    bcf indicador1, 0
    retfie
no_es_cierto:
    clrf indicador2
    bsf indicador1, 0    
    retfie
    
    end salchipapa