;Este es un comentario
    PROCESSOR 18F4550		;El modelo de microcontrolador
    #include "cabecera.inc"	;Llamada a lot bits de configuracion
    
    PSECT compuerta_not, class=CODE, reloc=2, abs   ;Declaracion de program section
    
compuerta_not:
    ORG 0000H			;Vector de RST
    goto configuro		;Salta a etiqueta configuro despues de un reset
    
    ORG 0020H			;Zona de programa de usuario
configuro:    
    ;aca van configuraciones de perifericos y registros
    bsf TRISB, 0	;Puerto RB0 es una entrada
    bcf TRISD, 0	;puerto RD0 sea una salida
    
lazo:				;Inicio de tu programa
    btfss PORTB, 0	;Pregunta si RB0 es uno
    goto falso		;Falso, salta a etiqueta "falso"
    bcf LATD, 0		;Verdadero, manda a cero el RD0
    goto lazo		;Retorna a preguntar de nuevo
    
falso:
    bsf LATD, 0		;Coloca a uno RD0
    goto lazo		;Retorna a preguntar de nuevo
    end compuerta_not

