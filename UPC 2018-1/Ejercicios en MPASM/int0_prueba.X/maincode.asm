    list p=18f4550
    #include "p18f4550.inc"

    CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))    
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
 
	org 0x000
	goto papanatas

	org 0x008
	goto enterrop
	
	org 0x020
papanatas:
	movlw 0xFC
	movwf TRISD	;RD0 y RD0 como salidas
	bsf TRISB, 0	;Forzamos a que RB0 (la interrupción externa 0) sea entrada
	bsf INTCON2, 6	;Forzamos a que INTEDG0 sea 1 (detección de flanco positivo)
	movlw 0x90
	movwf INTCON	;Habilitación de la INT0
inicio:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	goto inicio

enterrop:
	btfss PORTD, 0
	goto apagado
	bcf LATD, 0
	goto final
apagado:bsf LATD, 0
final:	bcf INTCON, INT0IF
	retfie
	end
	
	
