    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT maincode,class=CODE,reloc=2,abs
    ORG 00000H
maincode:
	    goto configuro
    
    ORG 00020H
configuro:
	    bcf TRISD, 5	    ;RD5 sea salida
	    movlw 0C0H
	    movwf T0CON		    ;Timer0 ON, 8BIT, FOSC/4, 1:2PS
inicio:	    btfss INTCON, 2	    ;Pregunto si se desbordo TMR0	    
	    goto inicio
	    nop
	    nop
	    btg LATD, 5		    ;Basculacion en RD5
	    movlw 11
	    movwf TMR0L		    ;Carga de cuenta inicial de 6 a TMR0
	    bcf INTCON, 2	    ;Bajamos la bandera de overflow del TMR0
	    goto inicio
	    
	    end maincode
	    
;NOTA: Hay que tomar en cuenta el tiempo de ejecución de las instrucciones	    


