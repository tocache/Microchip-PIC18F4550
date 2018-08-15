    list p=18f4550
    #include "p18f4550.inc"

    CONFIG  FOSC = XT_XT    
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))    
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
 
	org 0x000
	goto camote

	org 0x008
	goto enterrop
	
	org 0x020
camote:	bsf TRISB, 1	    ;Fuerzo el puerto B1 como entrada
	bsf TRISB, 0	    ;Fuerzo el puerto B0 como entrada
	movlw 0xFC
	movwf TRISD	    ;Puertos D0 y D1 como salidas
	bsf INTCON2, 6	    ;Interrupción externa 0 en flanco positivo
	movlw 0x90
	movwf INTCON	    ;Habilitación de INT0 y GIE
	
inicio:	btfss PORTB, 1
	goto nanana
	bcf LATD, 1
	goto inicio
nanana:	bsf LATD, 1
	goto inicio

;---Rutina de interrupción----------
enterrop:   btfss PORTD, 0
	    goto nonono
	    bcf LATD, 0
	    goto otro
nonono:	    bsf LATD, 0
otro:	    bcf INTCON, INT0IF	;Bajamos la banderita
	    retfie
	    end
	    
	
	
	