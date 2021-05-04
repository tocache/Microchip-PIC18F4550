;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    include "digbyte.inc"
    
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
    temporal
    Dig0
    Dig1
    Dig2
    Digtemp
    var_1ms_x
    var_1ms_y
    endc
    
;Valores de la tabla de busqueda para el siete segmentos    
    org 0x0400
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67 
 
    org 0x0000		    ;vector de reset
    goto init_conf
    
    org 0x0008		    ;vector de interrupcion
    goto TMR1_ISR
    
    org 0x0020
    
init_conf:  clrf TRISD		;RD como salidas para los segmentos del display
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) como salidas para los habilitadores del display
	    movlw 0x24
	    movwf ADCON2
	    movlw 0x1E
	    movwf ADCON1
	    movlw 0x01
	    movwf ADCON0
	    movlw 0x04
	    movwf TBLPTRH
	    clrf TBLPTRL	;TBLPTR apunte a la direccion 0x0400
	    movlw 0x0F
	    movwf T1CON	    ;configuracion del Timer1
	    bcf T1CON, T1OSCEN
	    movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;carga de cuenta inicial a TMR1
	    bsf PIE1, TMR1IE	;Habilitador de int de TMR1
	    bsf INTCON, PEIE	;Habilitador de int de perifericos
	    bsf INTCON, GIE	;Habilitadort global de int	    
	    
loop:	    ;movlw .34
	    ;movwf temporal
	    digbyte temporal
	    movff Dig2, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 0		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 0	    
	    movff Dig1, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 1		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 1	 
	    movff Dig0, TBLPTRL  ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 2		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 2	 
	    movlw 0x39
	    movwf LATD	    ;digito decena decodificado hacia RD
	    bsf LATB, 3		    ;habilitas digito 0 del display
	    call delay_mux	    ;pequeño retardo
	    bcf LATB, 3
	    goto loop
	    
TMR1_ISR:   movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L	    ;carga de cuenta inicial a TMR1
	    bsf ADCON0, GO
otro9:	    btfsc ADCON0, DONE
	    goto otro9
	    rrcf ADRESH, W  ;muevo un bit a la derecha para obtener los 7 bits de la conversion
	    andlw 0x7F
	    movwf temporal
	    bcf PIR1, TMR1IF
	    retfie
	    
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
	    
	    end