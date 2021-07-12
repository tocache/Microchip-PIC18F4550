;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librer�a de nombre de los registros
    
    ;Directivas de preprocesador o bits de configuraci�n
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

    org 0x0200
mensaje db 0x76, 0x3F, 0x38, 0x77	;mensaje a visualizar en el display
 
    org 0x0000		;vector de reset
    goto conf_ini
    
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
	    
loop:	    clrf TBLPTRL
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
		
		end
		