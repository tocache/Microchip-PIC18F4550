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
    uni_seg
    dec_seg
    endc

;Valores de la tabla de busqueda para el siete segmentos    
    org 0x0400
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67    
    
    org 0x0000	    ;vector de reset
    goto init_conf
    
    org 0x0008	    ;vector de interrupcion
    goto TMR1_ISR
    
init_conf:  movlw 0x80
	    movwf TRISD	    ;RD6:0 como salidas
	    bcf TRISB, 0
	    bcf TRISB, 1    ;habilitadores de los dígitos como salida
	    movlw 0x0F
	    movwf T1CON	    ;configuracion del Timer1
	    movlw 0x80
	    movwf TMR1H
	    clrf TMR1L	    ;carga de cuenta inicial a TMR1
	    bsf PIE1, TMR1IE	;Habilitador de int de TMR1
	    bsf INTCON, PEIE	;Habilitador de int de perifericos
	    bsf INTCON, GIE	;Habilitadort global de int
	    movlw 0x04
	    movwf TBLPTRH
	    clrf TBLPTRL	;TBLPTR apuntando a 0x0400
	    clrf uni_seg
	    clrf dec_seg
	    bcf LATB, 0
	    bcf LATB, 1
	    
loop:	    movff dec_seg, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 0		    ;habilitas digito 0 del display
	    call unops		    ;pequeño retardo
	    bcf LATB, 0		    ;deshabilito digito 0 del display
	    movff uni_seg, TBLPTRL  ;llamada a tabla para sacar unidad
	    TBLRD*
	    movff TABLAT, LATD	    ;digito unidad decodificado hacia RD
	    bsf LATB, 1		    ;habilito digito 1 del display
	    call unops		    ;pequeño retardo
	    bcf LATB, 1		    ;deshabilito digito 1 del display
	    goto loop		    ;vuelvo a hacer el proceso

unops:	    nop			    ;pequeño retardo para evitar perdida de intensidad
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
	    
TMR1_ISR:   movlw 0x80
	    movwf TMR1H
	    clrf TMR1L	    ;carga de cuenta inicial a TMR1
	    movlw .9
	    cpfseq uni_seg  ;uni_seg = 9?
	    goto no1
	    clrf uni_seg
	    movlw .5
	    cpfseq dec_seg  ;dec_seg = 5?
	    goto no2
	    clrf dec_seg
	    goto final
no1:	    incf uni_seg, f
	    goto final
no2:	    incf dec_seg, f
final:	    bcf PIR1, TMR1IF	;bajo bandera de desborde de TMR1
	    retfie		;retorno
	    end
	    ;fin del programa!