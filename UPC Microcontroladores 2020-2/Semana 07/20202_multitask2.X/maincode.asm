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

;Aquí va el cblock o declaración de nombres de GPR    
    cblock 0x000
	ESTADO
    endc
    
    org 0x0000
    goto init_conf
    
    org 0x0008
    goto INT0_ISR
    
    org 0x0018
    goto TMR0_TMR1_ISR

;Aquí se pueden declarar las constantes en la memoria de programa    

    org 0x0020
init_conf:
    bcf TRISD, 0    ;RD0 como salida
    bcf TRISD, 1    ;RD1 como salida
    movlw 0x88
    movwf T0CON	    ;Configuracion TMR0
    movlw 0x01
    movwf T1CON	    ;Configuración TMR1
    bsf RCON, IPEN  ;Habilito prioridades en ints.
    bcf INTCON2, TMR0IP	;TMR0 en baja prioridad
    bcf IPR1, TMR1IP	;TMR1 en baja prioridad
    bsf PIE1, TMR1IE	;Habilito int del TMR1
    bsf INTCON, INT0IE	;Habilito INT0
    bsf INTCON, TMR0IE	;Habilito int del TMR0
    bsf INTCON, GIEL	;Interruptor global low priority habilitado
    bsf INTCON, GIEH	;Interruptor global high priority habilitado
    clrf ESTADO		;Estado inicial = 0
    
loop:
    nop
    goto loop

INT0_ISR:
    btg ESTADO, 0	;Intercambio estado
    bcf INTCON, INT0IF	;Bajamos la bandera INT0
    retfie
    
TMR0_TMR1_ISR:
    btfss INTCON, TMR0IF    ;Pregunto si ocurrio TMR0
    goto fue_el_otro	    
    movlw 0xFE
    movwf TMR0H
    movlw 0xC2
    movwf TMR0L		    ;Cargo cuenta inicial en TMR0
    btfss ESTADO, 0	    ;Pregunto el ESTADO
    goto estado_cero_a
    btg LATD, 1		    ;Basculo RD1
    goto final_1
estado_cero_a:
    btg LATD, 0		    ;Basculo RD0
final_1:
    bcf INTCON, TMR0IF	    ;Bajamos bandera de TMR0
fue_el_otro:
    btfss PIR1, TMR1IF	    ;Pregunto si ocurrio TMR1
    retfie
    movlw 0xFF
    movwf TMR1H
    movlw 0x80
    movwf TMR1L		    ;Cargo cuenta inicial en TMR1
    btfss ESTADO, 0	    ;Pregunto el ESTADO
    goto estado_cero_b
    btg LATD, 0		    ;Basculo RD0
    goto final_2
estado_cero_b:
    btg LATD, 1		    ;Basculo RD1
final_2:
    bcf PIR1, TMR1IF	    ;Bajo bandera de TMR1
    retfie
    end