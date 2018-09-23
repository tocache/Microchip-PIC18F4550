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
	goto interrop
	
	org 0x0020
configuro:
	    bcf TRISD, 0	;Puerto D0 como salida, por donde saldrá la onda cuadrada
	    movlw 0xC0
	    movwf T0CON		;Timer0 con 1:2 y FOsc/4
	    movlw 0xA0
	    movwf INTCON	;Interrupción habilitada para Timer0

inicio:	    nop
	    goto inicio
	    
interrop:   movlw 0x0A
	    movwf TMR0L
	    btg LATD, 0
	    bcf INTCON, TMR0IF
	    retfie
	    
	    end