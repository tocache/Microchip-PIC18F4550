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
    
    org 0x0000
    goto init_conf
    
    org 0x0008
    goto TMR0_ISR
    
init_conf:  movlw 0x0F
	    movwf ADCON1	;Desactivando todos las I/O analógicas
	    clrf TRISE, 0	;RE0 como salida
	    movlw 0x81
	    movwf T0CON		;Tmr0: FOSC/4, PSC 1:4, 16bit mode
	    movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		;Cuenta inicial de Timer0
	    movlw 0xA0
	    movwf INTCON	;Interrupciones habilitadas para Timer0 (GIE=1, TMR0IE=1)
	    
loop:	    nop
	    goto loop

TMR0_ISR:   btfss PORTB, 0  ;Pregunto por RB0
	    goto falso
	    btg LATE, 0		;Basculo RE0
	    goto otro
falso:	    bcf LATE, 0		;RE0=0
otro:	    movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		;Carga de cuenta inicial 3036 a TMR0
	    bcf INTCON, TMR0IF	;Bajo la bandera de desborde del TMR0
	    retfie
	    end