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

    org 0x0000	    ;vector de reset
    goto init_conf
    
    org 0x0008	    ;vector de interrupcion
    goto TMR1_ISR
    
    org 0x0020	    ;zona de programa de usuario
init_conf:  clrf TRISD	    ;RD como salidas
	    movlw 0xFC
	    movwf TRISB	    ;RB(1:0) como salidas
	    movlw 0x0F
	    movwf T1CON	    ;configuracion de TMR1
	    movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;cuenta inicial en TMR1
	    bsf PIE1, TMR1IE	;interrupcion por TMR1 habilitado
	    bsf INTCON, PEIE	;interrupcion de perifericos habilitado
	    bsf INTCON, GIE	;interrupcion global habilitado
	    bsf LATB,1

loop:	    nop
	    goto loop
	    
TMR1_ISR:   movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;cuenta inicial en TMR1
	    btg LATD, 7	    ;basculamos RD7 (d.p.)
	    bcf PIR1, TMR1IF	;bajamos la bandera de TMR1
	    retfie
	    end