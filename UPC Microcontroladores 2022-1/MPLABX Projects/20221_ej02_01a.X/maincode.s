    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    clrf TRISB	    ;Todos los pines de RB como salidas

    clrf TRISD	    ;Todos los pines de RD como salidas

;    movlw 00H
;    movwf TRISD

;    movlw 00H
;    andwf TRISD
    
;    bcf TRISD, 7
;    bcf TRISD, 6
;    bcf TRISD, 5
;    bcf TRISD, 4
;    bcf TRISD, 3
;    bcf TRISD, 2
;    bcf TRISD, 1
;    bcf TRISD, 0
    
loop:
    movlw 0A5H	    
    movwf LATB
    movlw 5AH
    movwf LATD
    end principal

