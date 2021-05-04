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

    cblock 0x000
    unidad
    punto
    endc
    
;Valores de la tabla de busqueda para el siete segmentos    
    org 0x0400
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67 
 
    org 0x0000	    ;vector de reset
    goto init_conf
    
    org 0x0008	    ;vector de interrupcion
    goto TMR1_ISR
    
    org 0x0020	    ;zona de programa de usuario
init_conf:  clrf TRISD	    ;RD como salidas
	    movlw 0xF0
	    movwf TRISB	    ;RB(1:0) como salidas
	    movlw 0x0F
	    movwf T1CON	    ;configuracion de TMR1
	    movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;cuenta inicial en TMR1
	    bsf PIE1, TMR1IE	;interrupcion por TMR1 habilitado
	    bsf INTCON, PEIE	;interrupcion de perifericos habilitado
	    bsf INTCON, GIE	;interrupcion global habilitado
	    bcf LATB,1
	    bcf LATB,3		;ambos digitos deshabilitados
	    movlw 0x04
	    movwf TBLPTRH
	    clrf TBLPTRL	;TBLPTR apuntando a 0x0400
	    clrf unidad		;unidad empieza a cero

loop:	    movff unidad, TBLPTRL
	    TBLRD*
	    movff TABLAT, LATD
	    bsf LATB, 3
	    call udelay
	    bcf LATB, 3
	    clrf LATD
	    btfss punto, 0
	    goto apaga
	    bsf LATD, 7
	    goto otro
apaga:	    bcf LATD, 7	    
otro:	    bsf LATB, 1
	    call udelay
	    bcf LATB, 1
	    goto loop

udelay:	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    return
	    
TMR1_ISR:   movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;cuenta inicial en TMR1
	    btg punto, 0	    ;basculamos RD7 (d.p.)
	    btfss punto, 0
	    goto final
	    movlw .9
	    cpfseq unidad
	    goto noescierto
	    clrf unidad
	    goto final
noescierto: incf unidad, f	    
final:	    bcf PIR1, TMR1IF	;bajamos la bandera de TMR1
	    retfie
	    end