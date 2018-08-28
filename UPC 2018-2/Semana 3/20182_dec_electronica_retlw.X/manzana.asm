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

temporal EQU 0x0060
 
    org 0x0000				;Vector de RESET
    goto configuro

configuro:
	    clrf TRISD		    ;Puerto D como salida todos sus pines
	    movlw 0x62
	    movwf OSCCON	    ;Para que el oscilador interno funcione a 4MHz

inicio:	    movf PORTB, W	    ;Pasamos el contenido del puertoB hacia W
 	    andlw 0x0F		    ;Enmascaramiento de los cuatro primeros bits
	    movwf temporal	    ;Movemos el contenido a termporal
	    addwf temporal, W	    ;Sumamos el contenido de W a temporal
	    call tabla
	    movwf LATD
	    goto inicio

tabla:	    addwf PCL, f
	    retlw 0x79	;e
	    retlw 0x38	;l
	    retlw 0x79	;e
	    retlw 0x39	;c
	    retlw 0x78	;t
	    retlw 0x50	;r
	    retlw 0x5c	;o
	    retlw 0x54	;n
	    retlw 0x06	;i
	    retlw 0x39	;c
	    retlw 0x77	;a
	    
	    end