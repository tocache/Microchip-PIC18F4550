    PROCESSOR 18F4550				;Modelo del microcontrolador
    #include "cabecera.inc"			;Llamada a archivo cabecera
    
    PSECT not_gate, class=CODE, reloc=2, abs	;Creación de program section

not_gate:
    ORG 0000H					;Zona de vector de reset
    goto configuro
    
    ORG 0020H					;Zona de programa de usuario
configuro:
    ;Configuraciones iniciales adicionales
    bcf TRISD, 0				;RD0 es una salida
    bsf TRISB, 0				;RB0 es una entrada
    bcf TRISD, 3				;RD3 es una salida
    bsf TRISB, 3				;RB3 es una entrada
   
loop:
    btfss PORTB, 0				;Pregunto si RB0 es uno
    goto falso					;Falso, salta a etiqueta falso
    bcf LATD, 0					;Verdad, manda a 0 el RD0
    goto loop2					;Retorna al inicio (etiqueta loop)
falso:
    bsf LATD, 0					;Manda a 1 el RD0

loop2:						;Retorna al inicio (etiqueta loop)
    btfss PORTB, 3				;Pregunto si RB3 es uno
    goto falso2					;Falso, salta a etiqueta falso
    bcf LATD, 3					;Verdad, manda a 0 el RD3
    goto loop					;Retorna al inicio (etiqueta loop)
falso2:
    bsf LATD, 3					;Manda a 1 el RD3
    goto loop					;Retorna al inicio (etiqueta loop)    
    end not_gate
    
    
    





