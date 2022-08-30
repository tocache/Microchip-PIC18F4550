;Este es un comentario
    PROCESSOR 18F4550		;Modelo de microcontrolador
    #include "cabecera.inc"	;Llamado al archivo header
    
    PSECT comp_not, class=CODE, reloc=2, abs	;Declaración de program section
    
comp_not:
	    ORG 0000H		    ;Vector de reset 
	    goto configuro	    ;Salta a etiqueta configuro
	    
	    ORG 0020H		    ;Zona de programa de usuario
configuro:  bsf TRISB, 0	    ;pin RB0 como entrada
	    bcf TRISD, 0	    ;pin RD0 como salida

lazo:	    btfss PORTB, 0 	    ;Pregunto si RB0 es uno
	    goto falso		    ;Falso, salta a etiqueta falso
	    bcf LATD,0		    ;Verdadero, pone RD0 en cero
	    goto lazo		    ;Salta a etiqueta lazo (hacer de nuevo)

falso:	    bsf LATD, 0		    ;Pone RD0 en uno
	    goto lazo		    ;Salta a etiqueta lazo (hacer de nuevo)
	    
	    end comp_not	    ;Cierre del program section
    


