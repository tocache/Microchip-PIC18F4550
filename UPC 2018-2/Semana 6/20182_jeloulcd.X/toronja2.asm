;*******************************************************************************
    ;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include <p18f4550.inc>		;Llamo a la librería de nombre de los regs
    #include "LCD_LIB.asm"
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = INTOSCIO_EC	  ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    
    org 0x1000
mensaje da "Enyinieitors UPC$"	;El caracter $ es para indicar el fin del mensaje
    org 0x1100
mensaje2 da "Jelou Guorld$"	;El caracter $ es para indicar el fin del mensaje    
 
    org 0x0000
    goto configuro
    
    org 0x0020
    ;Según la librería el LCD esta conectado con el PIC: RS->RD0, RW->RD1, E->RD2, Datos->RD4-RD7
configuro:
    clrf TRISD	    ;Puertos como salida (conexión hacia el LCD
    call DELAY15MSEG	;Para inicializar el LCD para que arranque y funcione con interface de 4 bits
    call LCD_CONFIG
    CALL CURSOR_OFF
    
inicio:	movlw UPPER mensaje		;Puntero de tabla apuntando a mensaje
	movwf TBLPTRU
	movlw HIGH mensaje
	movwf TBLPTRH
	movlw LOW mensaje
	movwf TBLPTRL
otro1:	TBLRD*+
	movlw "$"
	cpfseq TABLAT
	goto imprime
	goto segunda

imprime:movf TABLAT, W
	call ENVIA_CHAR
	goto otro1

segunda:movlw UPPER mensaje2		;Puntero de tabla apuntando a mensaje
	movwf TBLPTRU
	movlw HIGH mensaje2
	movwf TBLPTRH
	movlw LOW mensaje2
	movwf TBLPTRL
	movlw .0
	call POS_CUR_FIL2
otro2:	TBLRD*+
	movlw "$"
	cpfseq TABLAT
	goto imprime2
	goto fin

imprime2:movf TABLAT, W
	call ENVIA_CHAR
	goto otro2
    
fin:	nop
	goto fin
	
	end