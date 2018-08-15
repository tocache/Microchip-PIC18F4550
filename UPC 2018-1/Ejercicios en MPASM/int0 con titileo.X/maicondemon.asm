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
 
;    cblock 0x0060
;	temp1
;	temp2
;	temp3
;	endc

temp1 equ 0x60
temp2 equ 0x61
temp3 equ 0x62
 
	org 0x000
	goto camote

	org 0x008
	goto enterrop
	
	org 0x018
	goto enterropa
	
	org 0x020
camote:	movlw b'11111000'	; Puertos D0 y D1 como salidas
	movwf TRISD
	bsf TRISB, 0		; Forzamos el puerto B0 como entrada
	movlw b'11000000'
	movwf T0CON	    ; habilitamos el Timer0 con FOsc/4 y PSC 1:2
	bsf RCON, 7		; Habilitación de interrupciones de baja prioridad
	movlw 0xF0
	movwf INTCON		; Activamos la interrupción externa INT0 y Timer0
	bsf INTCON2, 6		; Forzamos que la INT0 sea rising edge
	bcf INTCON2, 2		; Colocamos a la interrupción del Timer0 en BAJA PRIORIDAD
	
inicio:	bcf LATD, 1
	;call retardon
	nop
	bsf LATD, 1
	nop
	;call retardon
	goto inicio

retardon:   movlw .20
	    movwf temp1
otro1:	    call anid2
	    decfsz temp1, 1
	    goto otro1
	    return

anid2:	    movlw .100
	    movwf temp2
otro2:	    call anid3
	    decfsz temp2, 1
	    goto otro2
	    return	   

anid3:	    movlw .100
	    movwf temp3
otro3:	    decfsz temp3, 1
	    goto otro3
	    return	    

;------Rutina de interrupción-------
;Alta prioridad
enterrop:   btfss PORTD, 0
	    goto nununu
	    bcf LATD, 0
	    goto tratratra
nununu:	    bsf LATD, 0
tratratra:  bcf INTCON, INT0IF
	    retfie
	    
;Baja prioridad
enterropa:
	bcf INTCON, GIE	    ;A ver si desactivamos todas las interrupciones
	btfss PORTD, 2
	goto nunanu
	bcf LATD, 2
	goto tratra
nunanu:	bsf LATD, 2
tratra:	movlw .006
	movwf TMR0L
	bcf INTCON, TMR0IF
	bsf INTCON, GIE
	retfie	
	end