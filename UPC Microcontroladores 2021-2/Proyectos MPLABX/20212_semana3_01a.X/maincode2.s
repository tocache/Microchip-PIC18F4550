    PROCESSOR 18F4550
    #include "cabecera.inc"

entrada EQU 000H    ;Nombre a GPR 000H  
    PSECT VectRST,class=CODE,reloc=2
    PSECT code
    ORG 00000H
VectRST:    
    goto configuracion

    ORG 00020H
configuracion:	movlw 80H
		movwf TRISD	    ;RD0 al RD6 como salidas
inicio:		movf PORTB, w
		andlw 0FH
		movwf entrada
		movlw 00H
		cpfseq entrada
		goto siguiente1
		goto opcion0
siguiente1:	cpfseq entrada
		goto siguiente2
		goto opcion1
siguiente2:	cpfseq entrada
		goto opcion3
		goto opcion2
		
opcion0:	movlw 3FH
		movwf LATD
		goto inicio
		
opcion1:	movlw 06H
		movwf LATD
		goto inicio

opcion2:	movlw 5BH
		movwf LATD
		goto inicio
		
opcion3:	movlw 4FH
		movwf LATD
		goto inicio
				
		end VectRST


