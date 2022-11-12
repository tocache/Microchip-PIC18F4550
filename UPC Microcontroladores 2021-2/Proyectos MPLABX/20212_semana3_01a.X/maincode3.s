;Programa para visualizar el dígito 4 en el display de 7 segmentos
    PROCESSOR 18F4550
    #include "cabecera.inc"
    
    PSECT rstVect,class=CODE,reloc=2
    ORG 0000H
rstVect:    goto configuracion
    
    ORG 0020H
configuracion:	movlw 80H
		movwf TRISD	;RD6:RD0 como salidas
inicio:		movlw 01100110B	;dígito 4 en el disp 7 segm
		movwf LATD
		
		end rstVect


