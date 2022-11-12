    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT maincode,class=CODE,reloc=2,abs
    ORG 00000H
maincode:
	    goto configuro
	    
    ORG 00008H
	    goto TMR0_ISR
	    
    ORG 00020H
configuro:
	    bcf TRISD, 5	    ;RD5 sea salida
	    movlw 0C0H
	    movwf T0CON		    ;Timer0 ON, 8BIT, FOSC/4, 1:2PS
	    movlw 0A0H
	    movwf INTCON	    ;Habilitando la interrupcion de desborde de TMR0
	    
inicio:	    nop
	    goto inicio
	    
TMR0_ISR:   btg LATD, 5		    ;Basculacion en RD5
	    nop
	    movlw 12
	    movwf TMR0L		    ;Carga de cuenta inicial de 6 a TMR0
	    bcf INTCON, 2	    ;Bajamos la bandera de overflow del TMR0
	    retfie
	    
	    end maincode	;NOTA: Hay que tomar en cuenta el tiempo de ejecución de las instrucciones	    
