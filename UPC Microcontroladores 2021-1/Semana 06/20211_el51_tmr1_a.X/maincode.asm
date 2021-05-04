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
    
	org 0x0000	;vector de reset
	goto init_conf
	
	org 0x0008	;vector de interrupcion
	goto TMR1_ISR
	
	org 0x0020	;zona de programa de usuario
	
init_conf:  bcf TRISD, 4	;RD4 como salida
	    movlw 0x0F
	    movwf T1CON		;Timer1 on, psc 1:1. cristal 3K habilitado, asyn
	    ;bcf T1CON, T1OSCEN	;Si es que vas a usar el Proteus
	    bsf PIE1, TMR1IE	;Interrupción de TMR1 activada
	    bsf INTCON, PEIE	;Habilitador de int de perifericos activo
	    bsf INTCON, GIE	;interruptor global de interrupciones activado
	    setf TMR1H
	    clrf TMR1L		;Cuenta inicial en TMR1
loop:	    goto loop
    
TMR1_ISR:   btg LATD, 4		;basculo RD4
	    setf TMR1H
	    clrf TMR1L		;Cuenta inicial en TMR1
	    bcf PIR1, TMR1IF	;Bajamos la bandera de desborde del TMR1
	    retfie
	    end
	    