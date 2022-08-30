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
   
loop:
    btfss PORTB, 0				;Pregunto si RB0 es uno
    goto falso					;Falso, salta a etiqueta falso
    bcf LATD, 0					;Verdad, manda a 0 el RD0
    goto loop					;Retorna al inicio (etiqueta loop)
falso:
    bsf LATD, 0					;Manda a 1 el RD0
    goto loop					;Retorna al inicio (etiqueta loop)
    end not_gate				;Cierre del program section
    
    
    


