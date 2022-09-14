    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT rocoton, class=CODE, reloc=2, abs
rocoton:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    movlw 80H
    movwf TRISD	    ;salida para los segmentos
    movlw 0F0H
    movwf TRISB	    ;salida para los habilitadores
    bcf INTCON2, 7  ;RBPU habilitadas
    setf LATD	    ;encendemos todos los segmentos
    clrf LATB	    ;mandamos a cero todos los habilitadores
;    bcf OSCCON, 6
;    bcf OSCCON, 5
;    bcf OSCCON, 4   ;Configuracion de INTOSC para 31KHz
inicio:
    call muxxed
    goto inicio
    
muxxed:
    bsf LATB, 0
    call nopx8
    bcf LATB, 0
    bsf LATB, 1
    call nopx8
    bcf LATB, 1
    bsf LATB, 2
    call nopx8
    bcf LATB, 2
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