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

cuenta_reg EQU 0x000
 
	org 0x0500
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67
 
	org 0x0000	;vector de reset
	goto init_conf
	
	org 0x0008	;vector de interrupcion
	goto TMR1_ISR
	
init_conf:  movlw 0x80
	    movwf TRISD	    ;RD(6:0) como salidas
	    movlw 0x0F
	    movwf T1CON	    ;TMR1 on, PSC 1:1, t1oscen =1, async
	    movlw 0x80
	    movwf TMR1H
	    clrf TMR1L		;carga de cuenta inicial a TMR1
	    bsf PIE1, TMR1IE	;interrupcion de TMR1 habilitada
	    bsf INTCON, PEIE	;interruptor de interrupciones de perifericos activado
	    bsf INTCON, GIE	;interruptor global de interrupciones activado
	    clrf cuenta_reg	;limpiamos cuenta_reg
	    movlw 0x05
	    movwf TBLPTRH
	    movlw 0x00
	    movwf TBLPTRL	;TBLPTR apuntando a 0x0500

loop:	    movff cuenta_reg, TBLPTRL
	    TBLRD*
	    movff TABLAT, LATD
	    goto loop
	    
TMR1_ISR:   movlw 0x80
	    movwf TMR1H
	    clrf TMR1L		;carga de cuenta inicial a TMR1
	    movlw .9
	    cpfseq cuenta_reg	;pregunto si cuenta_reg=9
	    goto falso
	    clrf cuenta_reg	;verdadero, limpia cuenta_reg
	    goto otro
falso:	    incf cuenta_reg, f	;falso, incrementa cuenta_reg
otro:	    bcf PIR1, TMR1IF	;bajamos bandera TMR1IF
	    retfie		;retorno
	    end
