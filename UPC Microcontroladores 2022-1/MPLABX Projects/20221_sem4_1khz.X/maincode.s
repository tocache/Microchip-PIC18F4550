    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT mastercode,class=CODE,reloc=2,abs
    ORG 00000H	    ;Vector de reset
mastercode: goto configuracion
    
    ORG 00020H	    ;Zona de programa de usuario
configuracion:
    movlw 0C0H
    movwf T0CON	    ;Tmr0 FOSC/4, modo 8 bits, psc 1:2
    bcf TRISD, 5    ;RD5 como salida
inicio:
    btfss INTCON, 2 ;Pregunto si TMR0 se desbordó
    goto inicio
    btg LATD, 5	    ;Basculo RD5
    nop
    nop
    movlw 11
    movwf TMR0L	    ;Cargo cuenta inicial de 11 a TMR0
    bcf INTCON, 2   ;Bajo la bandera TMR0IF
    goto inicio
    
    END mastercode


