    PROCESSOR 18F4550
    #include "cabecera.inc"
        
    PSECT rstVect,class=CODE,reloc=2,abs

    ORG 0500H
 cadena: DB 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
 
    ORG 0000H
rstVect:    goto configuracion
    
    ORG 0020H
configuracion:	movlw 80H
		movwf TRISD	;RD6:RD0 como salidas
		clrf TBLPTRU
		movlw HIGH cadena
		movwf TBLPTRH
		movlw LOW cadena
		movwf TBLPTRL	    ;Asignamos direccion a TBLPTR (500H)
inicio:		movf PORTB, w
		andlw 0FH
		movwf TBLPTRL
		TBLRD*
		movff TABLAT, LATD
		goto inicio
		
    end rstVect














