    PROCESSOR 18F4550
    #include "cabecera.inc"

PSECT udata_acs
 entrada:
	DS  1

PSECT VectRST,class=CODE,reloc=2,abs
    ORG 00000H			    ;Vector de reset
VectRST:    
    goto configuracion
    ORG 00020H			    ;Zona de programa de usuario
configuracion:	movlw 80H
		movwf TRISD	    ;RD0 al RD6 como salidas
inicio:		movf PORTB, w	    ;Leemos RB y almacenamos el contenido en Wreg
		andlw 0FH	    ;Enmascaramiento de Wreg con 0FH
		movwf entrada	    ;GPR
		addwf entrada, w    ;Sumamos entrada+entrada y lo alojamos en Wreg
		call alternativo_PC ;Llamada a la LUT basado en retlw
		movwf LATD	    ;Mueve contenido de Wreg hacia RD
		goto inicio	    ;Salta a inicio
		
alternativo_PC:	addwf PCL, f	    ;LUT empleando PC l
		retlw 3FH	    ;que contiene los datos del
		retlw 06H	    ;decodificador BCD-7Seg
		retlw 5BH
		retlw 4FH
		retlw 66H
		retlw 6DH
		retlw 7DH
		retlw 07H
		retlw 7FH
		retlw 67H
		retlw 79H
		retlw 79H
		retlw 79H
		retlw 79H
		retlw 79H
		retlw 79H
		
		end VectRST
		

