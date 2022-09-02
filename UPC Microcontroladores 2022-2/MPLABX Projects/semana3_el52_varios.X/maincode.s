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
    btfsc PORTB, 2	;Pregunto si RB2 es cero
    goto no_se_presiono_RB2 ;Falso, salto a no_se_preciono_RB2
    bsf LATC, 0		;Verdad, mando RC0 a uno
    goto inicio		;Retorno a inicio
no_se_presiono_RB2:
    btfsc PORTB, 3	;Pregunto si RB3 es cero
    goto no_se_presiono_RB3 ;Falso, salto a no_se_presiono_RB3
    bcf LATC, 0		;Verdad, mando a RC0 a cero
    goto inicio
no_se_presiono_RB3:
    goto inicio		;Retorno a inicio
    end cebolla


