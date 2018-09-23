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
    
	org 0x0000
	goto configuro
	
	org 0x0008
	goto interroop
	
	org 0x0020
configuro:
	bcf TRISD, 0		;Puerto RD0 como salida
	movlw 0x90
	movwf INTCON		;Habilitamos interrupción por INT0
	bsf INTCON2, INTEDG0	;Forzamos que la INT0 sea rising_edge

inicio: nop
	goto inicio
	
interroop:
	btfss PORTD, 0
	goto apagao
	bcf LATD, 0
	goto otro
apagao:	bsf LATD, 0
otro:	bcf INTCON, INT0IF
	retfie
	
	end
