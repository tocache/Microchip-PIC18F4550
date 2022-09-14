    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT rocoton, class=CODE, reloc=2, abs
rocoton:
    ORG 000000H
    goto configuro

    ORG 000100H
;	    P    e    r    u	    
mensaje: db 73H, 79H, 50H, 3EH    
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD	    ;salida para los segmentos
    movlw 0F0H
    movwf TRISB	    ;salida para los habilitadores
    bcf INTCON2, 7  ;RBPU habilitadas
    clrf LATB	    ;mandamos a cero todos los habilitadores
    clrf TBLPTRU
    movlw HIGH mensaje
    movwf TBLPTRH
    movlw LOW mensaje
    movwf TBLPTRL	;Apuntamos TBLPTR a dir mem prog 100H
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
    
    end rocoton


