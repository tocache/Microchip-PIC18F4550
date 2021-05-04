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

posicion EQU 0x000    
    
    org 0x0200	    ;Mensaje: Hola UPC Ingenieria Mecatronica
mensaje db 0x00, 0x00, 0x00, 0x00, 0x76, 0x3F, 0x38, 0x77, 0x00, 0x3E, 0x73, 0x39, 0x00
mensaje2 db 0x06, 0x54, 0x6F, 0x79, 0x54, 0x06, 0x79, 0x50, 0x06, 0x77, 0x00
mensaje3 db 0x37, 0x79, 0x39, 0x77, 0x78, 0x50, 0x5C, 0x54, 0x06, 0x39, 0x77, 0x00, 0x00, 0x00, 0x00
 
    org 0x0000		;vector de reset
    goto conf_ini
    
    org 0x0008		;vector de interrupcion
    goto Tmr0_ISR
    
    org 0x0020			;zona de programa de usuario
conf_ini:   movlw 0x80
	    movwf TRISD		;RD(6:0) como salidas
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) como salidas
	    clrf LATB		;Habilitadores en cero
	    movlw HIGH mensaje
	    movwf TBLPTRH
	    movlw LOW mensaje
	    movwf TBLPTRL
	    movlw 0x81
	    movwf T0CON		;tomeri0 modo 16 bit, fosc/4, psc 1:8
	    movlw 0xA0
	    movwf INTCON	;interrupcion habilitada para timer0
	    clrf posicion
	    
loop:	    movff posicion, TBLPTRL
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 0		;encendemos digito0
	    call micro_delay
	    bcf LATB, 0		;apagamos digito0
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 1		;encendemos digito1
	    call micro_delay
	    bcf LATB, 1		;apagamos digito1
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 2		;encendemos digito2
	    call micro_delay
	    bcf LATB, 2		;apagamos digito2
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 3		;encendemos digito3
	    call micro_delay
	    bcf LATB, 3		;apagamos digito3
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
		
Tmr0_ISR:   movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		;Cuenta inicial de 3036 en Tmr0
	    movlw .37
	    cpfseq posicion	;pregunto si estoy en el ultimo mensaje
	    goto aunno
	    clrf posicion
	    goto otro
aunno:	    incf posicion, f
otro:	    bcf INTCON, TMR0IF	;bajamos la bandera de desborde de Tmr0    
	    retfie
	    end

		