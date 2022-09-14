    PROCESSOR 18F4550
    #include "cabecera.inc"

indice EQU 000H    
    
    PSECT rocoton, class=CODE, reloc=2, abs
rocoton:
    ORG 000000H
    goto configuro

    ORG 000100H
mensaje1: db 00H, 00H, 00H, 00H, 15H, 30H, 39H, 50H, 3FH, 39H, 3FH, 54H, 78H, 50H, 3FH, 38H, 77H, 5EH, 3FH, 50H, 79H, 6DH, 00H, 00H, 00H
    ORG 000008H
    goto ISR_Timer0

    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD	    ;salida para los segmentos
    movlw 0F0H
    movwf TRISB	    ;salida para los habilitadores
    bcf INTCON2, 7  ;RBPU habilitadas
    clrf LATB	    ;mandamos a cero todos los habilitadores
    clrf TBLPTRU
    movlw 81H
    movwf T0CON	    ;Timer0 ON, 16bit, fosc/4, psc 1:32
    movlw 0A0H
    movwf INTCON    ;Habilitamos interrupciones para Timer0
    movlw HIGH mensaje1	;imprime hola
    movwf TBLPTRH
    clrf indice	    ;indice inicializa en cero
    
inicio:
    movff indice, TBLPTRL
    call muxxed
    goto inicio
    
muxxed:
    TBLRD*+
    movff TABLAT, LATD
    bsf LATB, 0
    call nopx8
    bcf LATB, 0
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
    
ISR_Timer0:
    bcf INTCON, 2   ;Bajamos la bandera TMR0IF
    movlw 0BH
    movwf TMR0H
    movlw 0DCH
    movwf TMR0L	    ;carga de cuenta inicial 3036 a Timer0
    movlw 21
    cpfseq indice
    goto aun_no
    clrf indice
    retfie    
aun_no:
    incf indice, f
    retfie
    
    end rocoton








