;Programa para visualizar "Ingenieria" en el display de 7 segmentos con TBLPTR
    PROCESSOR 18F4550
    #include "cabecera.inc"
        
    PSECT rstVect,class=CODE,reloc=2

    PSECT data
    ORG 0500H
 cadena: DB 30H, 54H, 6FH, 7BH, 54H, 10H, 7BH, 50H, 10H, 5FH
 
;Declaración de nombre en GPR (para la subrutina repeticua)  
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
aunno:		TBLRD*+		    ;Lectura de contenido apuntado por TBLPTR y posterior incremento de la dirección
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








