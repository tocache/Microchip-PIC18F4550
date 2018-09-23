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
	
	org 0x0020
configuro:
	    bcf TRISB, 5	;Puerto RB5 como salida, por donde saldrá la onda cuadrada
	    movlw 0x80
	    movwf TRISD
	    
inicio:	    btfss PORTB, 1
	    goto falso
	    btfss PORTB, 0
	    goto unocero
	    goto unouno
	    
falso:	    btfss PORTB, 0
	    goto cerocero
	    goto cerouno

cerocero:   movlw 0x77
	    movwf LATD
	    bsf LATB, 5
	    movlw 0xC8
	    movwf T0CON
	    movlw .106
	    movwf TMR0L
	    bcf INTCON, TMR0IF
otro1:	    btfss INTCON, TMR0IF
	    goto otro1
	    bcf LATB, 5
	    movlw 0xC1
	    movwf T0CON
	    movlw .44
	    movwf TMR0L
	    bcf INTCON, TMR0IF
otro2:	    btfss INTCON, TMR0IF
	    goto otro2
	    goto inicio

cerouno:    movlw 0x7C
	    movwf LATD
	    bsf LATB, 5
	    movlw 0xC0
	    movwf T0CON
	    movlw .6
	    movwf TMR0L
	    bcf INTCON, TMR0IF
otro3:	    btfss INTCON, TMR0IF
	    goto otro3
	    bcf LATB, 5
	    movlw 0xC0
	    movwf T0CON
	    movlw .6
	    movwf TMR0L
	    bcf INTCON, TMR0IF
otro4:	    btfss INTCON, TMR0IF
	    goto otro4
	    goto inicio
	    
unocero:    movlw 0x39
	    movwf LATD
	    bsf LATB, 5
	    movlw 0xC1
	    movwf T0CON
	    movlw .44
	    movwf TMR0L
	    bcf INTCON, TMR0IF
otro5:	    btfss INTCON, TMR0IF
	    goto otro5
	    bcf LATB, 5
	    movlw 0xC8
	    movwf T0CON
	    movlw .106
	    movwf TMR0L
	    bcf INTCON, TMR0IF
otro6:	    btfss INTCON, TMR0IF
	    goto otro6
	    goto inicio
	    
unouno:	    movlw 0x5E
	    movwf LATD
	    bsf LATB, 5
	    goto inicio

	    end