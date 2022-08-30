    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT principal, class=CODE, reloc=2, abs

principal:
    ORG 0000H
    goto configuro
    ORG 0020H

configuro:
NUM_A equ 000H	    ;Registro de NUM_A en GPR 000H
NUM_B equ 001H	    ;Registro de NUM_B en GPR 001H
 
    movlw 0F8H
    movwf TRISD	    ;RD2, RD1 y RD0 como salidas
    
loop:
    movf PORTB, 0   ;Leo RB y lo paso a WReg
    movwf NUM_A
    movwf NUM_B
alg_NUM_A:
    swapf NUM_A, 0  ;Intercambio de nibbles y resultado almacenado en WReg
    andlw 0FH
    movwf NUM_A
alg_NUMB:
    movf NUM_B, 0   ;Muevo NUM_B hacia WReg
    andlw 0FH
    movwf NUM_B
compara:
    movf NUM_B, 0
    cpfsgt NUM_A    ;Comparar NUM_A>NUM_B
    goto sigue1
    movlw 01H
    movwf LATD	    ;Enciendo LED NUM_A>NUM_B
    goto loop
sigue1:
    movf NUM_B, 0
    cpfseq NUM_A    ;Comparar NUM_A=NUM_B
    goto menor
    movlw 02H
    movwf LATD	    ;Enciendo LED NUM_A=NUM_B
    goto loop
menor:
    movlw 04H
    movwf LATD	    ;Enciendo LED NUM_A<NUM_B
    goto loop
    end principal


