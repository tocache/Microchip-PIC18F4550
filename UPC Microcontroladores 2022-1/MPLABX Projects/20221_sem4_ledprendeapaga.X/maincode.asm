;Se esta empleando el INTOSC que por defecto esta a 1MHz
;Esto significa que cada instrucción se esta ejecutando a 4us
    
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
variablon1 EQU 000H	    ;declarar nombre al GPR 000H    
variablon2 EQU 001H	    ;declarar nombre al GPR 001H    
    
    ORG 0000H
    goto configuro	    ;salta a etiqueta configuro
    ORG 0020H

configuro:
	bcf TRISD, 2	    ;RD2 como salida
	clrf variablon1	    ;variablon1 = 0
	clrf variablon2	    ;variablon2 = 0
	
loop:
	bsf LATD, 2	    ;LED encendido
	call retardo	    ;llamada a subrutina retardo
	bcf LATD, 2	    ;LED apagado
	call retardo	    ;llamada a subrutina retardo
	goto loop	    ;salta a etiqueta loop
	
retardo:call anillo
	decfsz variablon1, 1 ;decrementa variablon1 y pregunta si llego a cero
	goto retardo	     ;falso, salta a etiqueta retardo
	return		     ;verdadero, retorna
	
anillo:	nop		    ;se esta ejecutando 65536 veces
	decfsz variablon2, 1;decrementa variablon2 y pregunta si llego a cero
	goto anillo	    ;falso, salta a etiqueta anillo
	return		    ;verdadero, retorna
    
    end principal


