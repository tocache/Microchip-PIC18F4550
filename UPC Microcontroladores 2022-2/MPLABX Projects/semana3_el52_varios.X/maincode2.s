    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT cebolla, class=CODE, reloc=2, abs
cebolla:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;Activamos weak pullup de RB
inicio:
    btfsc PORTB, 1	;Preguntamos si presionaste el B2
    goto inicio		;falso: retorna a inicio
    btg LATC, 0		;verdad: complementa RC0
otro:
    btfss PORTB, 1	;Preguntamos si soltaste el B2
    goto otro		;falso: sigue preguntando si soltaste B2
    goto inicio		;retorna a inicio
    end cebolla





