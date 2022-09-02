;Este es un comentario
;Los comentarios tienen que tener un punto y coma antes
;Este programa emulara una co,mputerta NOT de un bit en
;un microcontrolador PIC18F4550
;Hecho por Kalun
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT unico, class=CODE, reloc=2, abs
unico:
    ORG 000000H	    ;vector de RESET
    goto configuro
    
    ORG 000020H	    ;Zona de programa de usuario
configuro:
    bsf TRISB, 0    ;puerto RB0 como entrada
    bcf TRISD, 0    ;puerto RD0 como salida
lazo:
    btfss PORTB, 0  ;pregunto si RB0 es uno
    goto falso	    ;cuando es falso, salta a etiqueta falso
    bcf LATD, 0	    ;cuando es verdad, pone RD0 a cero
    goto lazo	    ;salto a etiqueta lazo
falso:
    bsf LATD, 0	    ;pone RD0 a uno
    goto lazo	    ;salto a etiqueta lazo
    
    end unico	    ;cierre del program section
    


