;Este es un comentario
    PROCESSOR 18f4550		    ;Modelo del microcontrolador a usar
    #include "cabecera.inc"	    ;Llamar a la cabecera
    
    PSECT inicial, class=CODE, reloc=2, abs ;Declaracion del program section
inicial:    
    ORG 0000H			    ;Vector de RESET
    goto configuro		    ;Salto a configuro
    
    ORG 0020H			    ;Zona de programa de usuario
configuro:
    ;configuraciones iniciales
    bsf TRISB, 0		    ;Asignamos a RB0 como entrada
    bcf TRISD, 0		    ;Asignamos a RD0 como salida
    
loop:
    ;aquí va el programa de la aplicación
    btfss PORTB, 0		    ;Preguntamos si RB0 es uno
    goto falso			    ;Falso, sato a etiqueta falso
    bcf LATD, 0			    ;Verdadero, coloco el RD0 a cero
    goto loop			    ;Salto a etiqueta loop
    
falso:
    bsf LATD, 0			    ;Coloco RD0 a uno
    goto loop			    ;Salto a etiqueta loop
    
    end inicial			    ;Fin del program section
    
    


