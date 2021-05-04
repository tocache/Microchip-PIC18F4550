;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuración
    CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
    CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0400
;mensaje db b'01110110', b'00111111', b'00111000', b'01110111'	;palabra HOLA
;mensaje db 0x73, 0x79, 0x50, 0x3E				;palabra Peru
mensaje db 0x79, 0x50, 0x5C, 0x6D				;palabra Eros
 
    org 0x0500
mensaje2 db 0x06, 0x1C, 0x77, 0x54				;palabra Ivan
 
    org 0x0600
mensaje3 db 0x76, 0x3E, 0x77, 0x37			    ;palabra Huam
 
    org 0x0700
mensaje4 db 0x77, 0x54, 0x06, 0x00			   ;palabra ani
 
    org 0x0000		    ;vector de reset
    goto init_conf
    
    org 0x0008
    goto Tmr0_ISR	    ;vector de interrupcion
    
    org 0x0020		    ;zona de programa de usuario
init_conf:  movlw 0x80
	    movwf TRISD	    ;RD(6:0) como salidas
	    movlw 0xF0
	    movwf TRISB	    ;RB(3:0) como salidas
	    clrf LATB	    ;Habilitadores de los digitos en cero
;	    movlw 0x04
;	    movwf TBLPTRH
;	    movlw 0x00
;	    movwf TBLPTRL
	    movlw HIGH mensaje
	    movwf TBLPTRH
	    movlw 0x83
	    movwf T0CON	    ;Timer0 on, fosc/4, psc 1:8, modo 16 bit
	    movlw 0xA0
	    movwf INTCON    ;Interrupts activado para Timer0
	    
loop:	movlw LOW mensaje
	movwf TBLPTRL	;TBLPTR esta apuntando a mensaje en 0x0400
	TBLRD*+
	movff TABLAT, LATD
	bsf LATB, 0
	call micro_delay
	bcf LATB, 0
	TBLRD*+
	movff TABLAT, LATD
	bsf LATB, 1
	call micro_delay
	bcf LATB, 1
	TBLRD*+
	movff TABLAT, LATD
	bsf LATB, 2
	call micro_delay
	bcf LATB, 2
	TBLRD*+
	movff TABLAT, LATD
	bsf LATB, 3
	call micro_delay
	bcf LATB, 3
	goto loop

micro_delay:	nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		return
	
Tmr0_ISR:   movlw 0x07
	    cpfseq TBLPTRH
	    goto aunno
	    movlw 0x04
	    movwf TBLPTRH
	    goto otro
aunno:	    incf TBLPTRH, f	    
otro:	    bcf INTCON, TMR0IF	    
	    retfie
	    end