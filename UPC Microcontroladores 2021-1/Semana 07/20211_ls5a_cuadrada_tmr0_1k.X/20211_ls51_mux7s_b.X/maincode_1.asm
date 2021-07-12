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
    
    org 0x0000		;vector de reset
    goto init_conf
    
    org 0x0020		;zona de programa de usuario
init_conf:  movlw 0x80
	    movwf TRISD		;RD(6:0) como salidas - a los segmentos
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) como salidas - a los habilitadores
	    clrf LATB		;Cond. inicial de los habilitadores
	    
loop:	    movlw 0x77		    ; letra A
	    movwf LATD
	    bsf LATB, 0		    ; habilitamos digito 0
	    bcf LATB, 0		    ;deshabilitamos digito 0
	    movlw 0x37		    ; letra M
	    movwf LATD
	    bsf LATB, 1		    ; habilitamos digito 1
	    bcf LATB, 1		    ;deshabilitamos digito 1
	    movlw 0x5C		    ; letra O
	    movwf LATD
	    bsf LATB, 2		    ; habilitamos digito 2
	    bcf LATB, 2		    ;deshabilitamos digito 2
	    movlw 0x50		    ; letra R
	    movwf LATD
	    bsf LATB, 3		    ; habilitamos digito 3
	    bcf LATB, 3		    ;deshabilitamos digito 3
	    goto loop
	    end