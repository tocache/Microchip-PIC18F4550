;Programa para visualizar "Ingenieria" en el display de 7 segmentos con TBLPTR
    PROCESSOR 18F4550
    #include "cabecera.inc"
        
    PSECT rstVect,class=CODE,reloc=2

    PSECT data
    ORG 0500H
 cadena: DB 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x79, 0x79, 0x79, 0x79, 0x79, 0x79
 
;Declaraci�n de nombre en GPR (para la subrutina repeticua)  
var_i EQU 000H  
var_j EQU 001H
var_k EQU 002H
cuenta EQU 003H
 
    PSECT code
    ORG 0000H
rstVect:    goto configuracion
    
    ORG 0020H
configuracion:	movlw 80H
		movwf TRISD	;RD6:RD0 como salidas
inicio:		movlw HIGH cadena
		movwf TBLPTRH
		movlw LOW cadena
		movwf TBLPTRL	    ;Asignamos direccion a TBLPTR (500H)
		clrf cuenta	    ;Cuenta a cero
loop:		movlw 10	    ;cuenta es la cantidad de caracteres a visualizar
		cpfseq cuenta	    ;Preguntamos si cuenta = 3
		goto aunno	    ;Falso (cuenta diferente de 3)
		goto inicio	    ;Verdadero (cuenta llego a 3)
aunno:		TBLRD*+		    ;Lectura de contenido apuntado por TBLPTR y posterior incremento de la direcci�n
		movff TABLAT, LATD  ;Mueve contenido de TABLAT hacia RD
		call repeticua	    ;Llamada a subrutina de retardo
		incf cuenta, f	    ;Incremento de cuenta
		goto loop

repeticua:   
    movlw 80
    movwf var_i, b
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i, 1, 0
    goto otro1
    return

bucle1:
    movlw 80
    movwf var_j, b
otro2:
    call bucle2		;Salto a subrutina
    decfsz var_j, 1, 0
    goto otro2
    return
    
bucle2:
    movlw 20
    movwf var_k, b
otro3:
    nop			
    decfsz var_k, 1, 0
    goto otro3
    return			

    end rstVect











