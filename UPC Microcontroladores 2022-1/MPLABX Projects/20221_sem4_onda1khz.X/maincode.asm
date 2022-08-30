    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    bcf TRISD, 5	;RD5 como salida
    movlw 0C0H		;Timer0 ON, modo 8bit, 1:2PSC, FOSC/4
    movwf T0CON
    
loop:	movlw 6
	movwf TMR0L	;Cuenta inicial de 6
otro:	btfss INTCON, 2	;Pregunta si TMR0IF=1
	goto otro
	btg LATD, 5	;Basculamos RD5 para que genere la onda cuadrada
	bcf INTCON, 2	;Bajando la bandera TMR0IF
	goto loop
    
    end principal


