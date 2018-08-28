;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador(Single-Supply ICSP disabled)
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
  
    ;Zona de los bits de configuración (falta)
;    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (INTOSC = 8MHz)
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit t (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bi

    cblock 0x0060
	var_i
	var_j
	var_k
	temporal
	cuenta
	endc

    org 0x0100
letras db    0x37, 0x79, 0x39, 0x77, 0x78, 0x50, 0x5C, 0x54, 0x06, 0x39, 0x77, 0x00
 
    org 0x0000				;Vector de RESET
    goto configuro

configuro:
	    clrf TRISD		    ;Puerto D como salida todos sus pines
	    movlw 0x62
	    movwf OSCCON	    ;Para que el oscilador interno funcione a 4MHz
	    movlw UPPER letras
	    movwf TBLPTRU
	    movlw HIGH letras
	    movwf TBLPTRH
	    movlw LOW letras
	    movwf TBLPTRL

inicio:	    clrf cuenta

continua:   movlw .11
	    cpfsgt cuenta
	    goto aunno
	    goto inicio
	    
aunno:	    movf cuenta, W
	    movwf TBLPTRL
	    TBLRD*
	    movff TABLAT, LATD
	    call retardado
	    incf cuenta, f
	    goto continua
	
retardado:
	    movlw .100
	    movwf var_i
otro1:	    call bucle1
	    decfsz var_i, 1
	    goto otro1
	    return
	    
bucle1:	    movlw .50
	    movwf var_j
otro2:	    call bucle2
	    decfsz var_j, 1
	    goto otro2
	    return

bucle2:	    movlw .10
	    movwf var_k
otro3:	    nop
	    decfsz var_k, 1
	    goto otro3
	    return
	    
	    end