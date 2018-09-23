    list p=18f4550
    #include "p18f4550.inc"

    CONFIG  FOSC = XT_XT    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
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
	bcf TRISD, 0	    ; por acá saldrá señal de 1KHz
	movlw b'11000000'
	movwf T0CON	    ; habilitamos el Timer0 con FOsc/4 y PSC 1:2
	movlw 0xA0
	movwf INTCON	    ; habilitamos la interrupción de Timer0
inicio:
	nop
	goto inicio

enterrop:
	comf LATD, 1
	movlw .006
	movwf TMR0L
	bcf INTCON, TMR0IF
	retfie
	end