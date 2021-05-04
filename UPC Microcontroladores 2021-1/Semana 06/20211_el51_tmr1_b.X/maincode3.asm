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
    uni_min
    dec_min
    uni_hr
    dec_hr
    ticks
    var_1ms_x
    var_1ms_y
    endc

;Valores de la tabla de busqueda para el siete segmentos    
    org 0x0400
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67    
    
    org 0x0000	    ;vector de reset
    goto init_conf
    
    org 0x0008	    ;vector de interrupcion
    goto TMR1_ISR
    
init_conf:  movlw 0x00
	    movwf TRISD	    ;RD6:0 como salidas
	    movlw 0xF0    ;habilitadores de los dígitos como salida
	    movwf TRISB
	    movlw 0x0F
	    movwf T1CON	    ;configuracion del Timer1
	    movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;carga de cuenta inicial a TMR1
	    bsf PIE1, TMR1IE	;Habilitador de int de TMR1
	    bsf INTCON, PEIE	;Habilitador de int de perifericos
	    bsf INTCON, GIE	;Habilitadort global de int
	    movlw 0x04
	    movwf TBLPTRH
	    clrf TBLPTRL	;TBLPTR apuntando a 0x0400
	    clrf ticks
	    clrf uni_seg
	    clrf dec_seg
	    movlw .7
	    movwf uni_min
	    movlw .4
	    movwf dec_min
	    movlw .3
	    movwf uni_hr
	    movlw .2
	    movwf dec_hr
	    clrf LATB
	    
loop:	    movff dec_hr, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 0		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 0		    ;deshabilito digito 0 del display
	    movff uni_hr, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 1		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 1		    ;deshabilito digito 0 del display
	    movff dec_min, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    btfss ticks, 0
	    goto apagado
	    bsf LATD, 7
	    goto salida
apagado:    bcf LATD, 7	    
salida:	    bsf LATB, 2		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 2		    ;deshabilito digito 0 del display
	    movff uni_min, TBLPTRL  ;llamada a tabla para sacar unidad
	    TBLRD*
	    movff TABLAT, LATD	    ;digito unidad decodificado hacia RD
	    btfss ticks, 0
	    goto apagado2
	    bsf LATD, 7
	    goto salida2
apagado2:   bcf LATD, 7	    
salida2:    bsf LATB, 3		    ;habilito digito 1 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 3		    ;deshabilito digito 1 del display
	    goto loop		    ;vuelvo a hacer el proceso

delay_mux:  movlw .80
	    movwf var_1ms_x
aun_no1:    call anid1
	    decfsz var_1ms_x, f
	    goto aun_no1
	    return
anid1:	    movlw .10
	    movwf var_1ms_y
aun_no2:    nop
	    decfsz var_1ms_y, f
	    goto aun_no2
	    return
	    
TMR1_ISR:   movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;carga de cuenta inicial a TMR1
	    btfss ticks, 0  ;ticks = 1?
	    goto no0
	    bcf ticks, 0
	    movlw .9
	    cpfseq uni_seg  ;uni_seg = 9?
	    goto no1
	    clrf uni_seg
	    movlw .5
	    cpfseq dec_seg  ;dec_seg = 5?
	    goto no2
	    clrf dec_seg
	    movlw .9
	    cpfseq uni_min  ;uni_min = 9?
	    goto no3
	    clrf uni_min
	    movlw .5
	    cpfseq dec_min  ;dec_min = 5?
	    goto no4
	    clrf dec_min
	    movlw .2
	    cpfseq dec_hr
	    goto no5
	    movlw .3
	    cpfseq uni_hr
	    goto no6
	    clrf uni_hr
	    clrf dec_hr
	    goto final
no0:	    bsf ticks, 0
	    goto final
no6:	    incf uni_hr, f
	    goto final
no5:	    movlw .9
	    cpfseq uni_hr
	    goto no9
	    clrf uni_hr
	    incf dec_hr, f
	    goto final
no9:	    incf uni_hr, f	    
	    goto final
no1:	    incf uni_seg, f
	    goto final
no2:	    incf dec_seg, f
	    goto final
no3:	    incf uni_min, f
	    goto final
no4:	    incf dec_min, f
final:	    bcf PIR1, TMR1IF	;bajo bandera de desborde de TMR1
	    retfie		;retorno
	    end
	    ;fin del programa!