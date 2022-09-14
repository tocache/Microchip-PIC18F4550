    PROCESSOR 18F4550
    #include "cabecera.inc"

msg_actual EQU 000H    
    
    PSECT rocoton, class=CODE, reloc=2, abs
rocoton:
    ORG 000000H
    goto configuro

    ORG 000100H
;	    P    e    r    u	    
mensaje1: db 73H, 79H, 50H, 3EH    
    ORG 000200H 
;	    H    o    l    a	    
mensaje2: db 76H, 3FH, 38H, 77H    
 
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
    movlw 84H
    movwf T0CON	    ;Timer0 ON, 16bit, fosc/4, psc 1:32
    movlw 0A0H
    movwf INTCON    ;Habilitamos interrupciones para Timer0
    clrf msg_actual ;msg_actual inicializa en cero
    movlw HIGH mensaje2	;imprime hola
    movwf TBLPTRH
    
inicio:
    clrf TBLPTRL	;Posicion de TBLPTR a 100H
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
    btfss msg_actual, 0
    goto mensaje_1
    goto mensaje_2
mensaje_1:    
    movlw HIGH mensaje1	;verdad, imprime peru
    movwf TBLPTRH
    bsf msg_actual, 0	;cambio de msg al desborde
    retfie
mensaje_2:    
    movlw HIGH mensaje2	;imprime hola
    movwf TBLPTRH
    bcf msg_actual, 0	;cambio de msg al desborde
    retfie    
    
    end rocoton





