;Este es un comentario
    PROCESSOR 18F4550		;Modelo de microcontrolador
    #include "cabecera.inc"	;Llamada al header
    
    PSECT principal, class=CODE, reloc=2, abs	;Declaracion del program section

principal:
    ORG 0000H			;Vector de RESET
    goto configuro
    
    ORG 0020H			;Zona de programa de usuario
configuro:
    bsf TRISB, 0		;Puerto RB0 como entrada
    bcf TRISD, 0		;Puerto RD0 como salida
lazo:
    btfss PORTB, 0		;Preguntando si RB0 es uno
    goto a_falso		;Falso, salta a etiqueta a_falso
    bcf LATD, 0			;Verdadero, pone RD0 a cero
    goto lazo			;Retorno a preguntar nuevamente la entrada

a_falso:
    bsf LATD, 0			;Pone RD0 a uno
    goto lazo			;Retorno a preguntar nuevamente la entrada
    
    end principal		;Cierre del program section


