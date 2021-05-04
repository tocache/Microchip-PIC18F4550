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
    
    org 0x0020
init_conf:  bcf TRISD, 3	    ;RD3 como salida
	    movlw 0xC0
	    movwf T0CON		    ;Timer0: FOSC/4, PSC 1:2, 8bit mode

inicio:	    movlw .14
	    movwf TMR0L		    ;Cuenta inicial de 6 al TMR0
aunno:	    btfss INTCON, TMR0IF    ;Pregunto si la bandera de desborde del TMR0 se levanto
	    goto aunno
	    btg LATD, 3		    ;Complemento a RD3
	    nop
	    nop
	    bcf INTCON, TMR0IF	    ;Bajo la bandera de indicacion de desborde de TMR0
	    goto inicio
	    end