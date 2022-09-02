    PROCESSOR 18F45K50
    #include "cabecera.inc"
    
    PSECT camote, class=CODE, reloc=2, abs
camote:
    ORG 000000H
    goto configuro
    
    ORG 000020H
configuro:
    bcf TRISC, 0	;RC0 como salida
    bcf INTCON2, 7	;RBPU=0 res weak pull-up en RB activadas
    
lazo:
    btfsc PORTB, 1	;Pregunto si presionaste RB1
    goto lazo		;Falso: No presionaste regresa a preguntar
    btg LATC, 0		;Verdad: Basculo RC0 (enciendo o apago el LED)
otro:
    btfss PORTB, 1	;Pregunto si dejaste de presionar RB1
    goto otro		;Falso, sigues presionando RB1 regresa a preguntar
    goto lazo		;Retorno a lazo
    end camote




