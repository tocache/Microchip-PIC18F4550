;Este es un comentario
    PROCESSOR 18F4550		;Modelo de procesador
    #include "cabecera.inc"	;Llamada a cabecera
    
    PSECT principal, class=CODE, reloc=2, abs	;Declaración del program section

principal:
    ORG 0000H			;Vector RESET
    goto configuro		;Salto a etiqueta configuro
    
    ORG 0020H			;Zona de programa de usuario
configuro:
    ;instrucciones para configurar puertos, regs, etc
    bsf TRISB, 0		;Puerto RB0 como entrada
    bcf TRISD, 0		;Puerto RD0 como salida
        
loop:				;Programa de la aplicación
    btfss PORTB, 0		;Pregunto si RB0 es uno
    goto s_falso		;Falso, salta a etiqueta s_falso
    bcf LATD, 0			;Verdadero, pone RD0 a cero
    goto loop			;Salto a loop
    
s_falso:
    bsf LATD, 0			;Poner RD0 a uno
    goto loop			;Salto a loop
    
    end principal		;Cierre del program section


