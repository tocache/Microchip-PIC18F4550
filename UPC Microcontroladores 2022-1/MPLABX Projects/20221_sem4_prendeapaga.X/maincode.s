;Se esta empleando INTOSC, al estar por defecto funciona a 1MHz (4us cada instr)
    
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
variable1 EQU 000H
variable2 EQU 001H	;Declaracion de nombres a GPRs 
    
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
    bcf TRISD, 0	;RD0 como salida
    bcf OSCCON, 6
    bcf OSCCON, 5
    bcf OSCCON, 4	;INTOSC entrega 31KHz al CPU
    clrf variable1	;variable1 a cero

    
loop:
    bsf LATD, 0		;RD0=1
    call nopes
    bcf LATD, 0		;RD0=0
    call nopes
    goto loop

nopes:
    decfsz variable1, 1	;decremento y pregunto si variable1 = 0
    goto aunno
    return
    
aunno:
    nop
    goto nopes
    
    end principal
