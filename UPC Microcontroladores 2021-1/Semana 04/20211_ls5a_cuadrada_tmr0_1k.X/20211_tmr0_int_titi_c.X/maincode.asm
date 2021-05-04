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
    goto Tmr0_ISR
    
init_conf:  bcf TRISB, 6	;RB6 como salida
	    movlw 0x82
	    movwf T0CON		;Timer0 modo 16bit, PSC 1:8, fosc/4
	    movlw 0xA0
	    movwf INTCON	;GIE=1, TMR0IE=1
	    movlw 0x5D
	    movwf TMR0H
	    movlw 0x3D
	    movwf TMR0L		;Carga de cuenta inicial a TMR0: 0x5D3D (23869)

loop:	    nop
	    goto loop
	    
Tmr0_ISR:   btg LATB, 6
	    movlw 0x5D
	    movwf TMR0H
	    movlw 0x3D
	    movwf TMR0L		;Carga de cuenta inicial a TMR0: 0x5D3D (23869)
	    bcf INTCON, TMR0IF	;Bajamos bandera de TMR0
	    retfie
	    
	    end
