;Como se esta trabajando con el INTOSC, por defecto es 1MHz al CPU    
    
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs
cuenta EQU 000H		;GPR 000H con nombre cuenta
    
principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    bcf OSCCON, 6
    bcf OSCCON, 5
    bcf OSCCON, 4	;Configurando reloj del CPU a 31KHz
    bcf TRISD, 1	;RD1 como salida
    clrf cuenta
    
loop:
    bsf LATD, 1		;Enciendo LED
    call retardo
    bcf LATD, 1		;Apagar LED
    call retardo
    goto loop
    
retardo:
    decfsz cuenta, 1
    goto retardo
    nop
    return
    
    end principal





