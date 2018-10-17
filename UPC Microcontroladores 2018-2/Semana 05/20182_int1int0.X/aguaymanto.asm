;Este es un comentario, esta es una plantilla
    list p=18f4550			;Modelo del microcontrolador
    #include<p18f4550.inc>		;Llamo a la librería de nombre de los regs
    
    ;Zona de los bits de configuración (falta)
    CONFIG  FOSC = INTOSCIO_EC	  ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  MCLRE = OFF            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    
	org 0x0000
	goto configuro
	
	org 0x0008
	goto interr_high
	
	org 0x0018
	goto interr_low
	
	org 0x0020
configuro:  movlw 0x62
	    movwf OSCCON
	    bcf TRISD, 1	;Puerto RD1 como salida
	    bsf RCON, IPEN	;Habilitación de prioridades de interrupción
	    movlw 0xD0
	    movwf INTCON	;Habilitamos HIGH_INT, LOW_INT y INT0
	    bcf INTCON3, INT1IP	;Prioridad LOW para INT1
	    bsf INTCON3, INT1IE	;Habilitamos INT1
	    bsf INTCON2, INTEDG0 ;Rising_edge para INT0
	    bsf INTCON2, INTEDG1 ;Rising_edge para INT1

inicio:	nop
	goto inicio

interr_high:
	bsf LATD, 1		;Encendemos el LED1
	bcf INTCON, INT0IF	;Bajamos la bandera INT0IF
	retfie
	
interr_low:
	bcf LATD, 1		;Apagamos el LED1
	bcf INTCON3, INT1IF	;Bajamos la bandera INT1IF
	retfie
	
	end