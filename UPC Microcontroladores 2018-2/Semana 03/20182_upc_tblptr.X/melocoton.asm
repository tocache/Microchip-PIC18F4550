;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = XT_XT	  ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

;Declaramos nombres a registros GPR
    cblock 0x0020
	var_i
	var_j
	var_k
	cuenta
	endc
	
    org 0x0100
tablon db 0x3E, 0x73, 0x39, 0x00
tablon1 db 0x37, 0x79, 0x39, 0x77, 0x78, 0x50, 0x5C, 0x54, 0x06, 0x39, 0x77, 0x00
tablon2 db 0x79, 0x38, 0x79, 0x39, 0x78, 0x50, 0x5C, 0x54, 0x06, 0x39, 0x77, 0x00
 
 
    org 0x0000				;Vector de RESET
    goto configuro
    
    org 0x0020				;Zona de programa de usuario
configuro:
    ;Instrucciones de configuración inicial del programa de usuario
    movlw 0x80
    movwf TRISD			;Puerto RD(6:0) como salida
    movlw UPPER tablon		;|Establezco la dirección del TBLPTR
    movwf TBLPTRU		;|
    movlw HIGH tablon		;|
    movwf TBLPTRH		;|
    movlw LOW tablon		;|
    movwf TBLPTRL		;|
        
inicio:
    clrf cuenta
otravez:
;    movlw .3
;    cpfsgt cuenta
    goto aunno
    goto inicio
aunno:    
    movf cuenta, W
    movwf TBLPTRL
    TBLRD*

    movlw 0xFF
    cpfseq TABLAT
    goto valido
    goto inicio

valido:
    movff TABLAT, LATD
    call retardado
    incf cuenta, f
    goto otravez

retardado:
	    movlw .100
	    movwf var_i
otro1:	    call bucle1
	    decfsz var_i, 1
	    goto otro1
	    return
	    
bucle1:	    movlw .20
	    movwf var_j
otro2:	    call bucle2
	    decfsz var_j, 1
	    goto otro2
	    return

bucle2:	    movlw .30
	    movwf var_k
otro3:	    nop
	    decfsz var_k, 1
	    goto otro3
	    return
	    
    end