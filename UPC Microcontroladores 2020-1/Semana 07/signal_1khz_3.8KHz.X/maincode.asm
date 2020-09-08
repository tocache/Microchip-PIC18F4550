;Este es un comentario, se le antecede un punto y coma
;Ejemplo: Timer0 genera onda cuadrada en RB0 a 1KHz, Timer1 genera onda cuadrada a 3.8KHz
;Se esta usando prioridad en las interrupciones, Timer0 en baja prioridad, Timer1 en alta prioridad    
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

    org 0x0000		;Vector de RESET
    goto init_conf
    
    org 0x0008		;Vector de interrupción de alta prioridad
    goto TMR1_ISR
    
    org 0x0018		;Vector de interrupción de baja prioridad
    goto TMR0_ISR
    
    org 0x0020		;Zona de programa de usuario
init_conf:
	    ;Primero, configurar el Timer0 (T0CON)
	    movlw 0x88
	    movwf T0CON
	    ;Segundo, configurar el Timer1 (T1CON)
	    movlw 0x01
	    movwf T1CON
	    ;Tercero, configurar interrupciones (revisar los registros y el procedimiento)
	    bsf RCON, 7	    ;Prioridades de las interrupciones habilitadas
	    bcf INTCON2, TMR0IP ;TMR0 como interrupcion de baja prioridad
	    bsf INTCON, TMR0IE	;Habilitar interrupcion del desborde de TMR0
	    bsf PIE1, TMR1IE	   ;Habilitamos interrupcion por desborde de Timer1
	    bsf INTCON, GIEH	;Habilitacion de interrupciones globales de high priority
	    bsf INTCON, GIEL	;Habilitacion de interrupciones globales de low priority
	    ;Cuarto los puertos como salida
	    bcf TRISD, 0
	    bcf TRISB, 0
loop:
	nop
	goto loop

TMR1_ISR:		;Rutina para el evento de interrupción high priority
	btg LATD, 0
	movlw 0xFF
	movwf TMR1H
	movlw 0x7D
	movwf TMR1L	; Cargar 65036 en TMR0
	bcf PIR1, TMR1IF	;Bajamos bandera de desborde de TMR0
	retfie
	
TMR0_ISR:		;Rutina para el evento de interrupción low priority
	btg LATB, 0
	movlw 0xFE
	movwf TMR0H
	movlw 0x0C
	movwf TMR0L	; Cargar 65036 en TMR0
	bcf INTCON, TMR0IF	;Bajamos bandera de desborde de TMR0
	retfie
	    end		;Fin del programa