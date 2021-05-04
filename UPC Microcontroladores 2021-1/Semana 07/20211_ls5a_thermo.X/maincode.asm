;Este es un comentario, se le antecede un punto y coma
    list p=18f4550	;Modelo del microcontrolador
    #include <p18f4550.inc>	;Llamada a la librería de nombre de los registros
    include "digbyte.inc"	;Llamada a la libreria de obtencion de digitos en variable
    
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
    temporal			;almacenamiento temporal del resultado de A/D
    Dig0
    Dig1
    Dig2			
    Digtemp			;utilizados en la macro digbyte
    var_1ms_x
    var_1ms_y			;utilizados en el pequeño retardo
    endc
    
;Valores de la tabla de busqueda para el siete segmentos    
    org 0x0400
tabla_7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67 
 
    org 0x0000			;vector de reset
    goto init_conf
    
    org 0x0008			;vector de interrupcion
    goto TMR1_ISR
    
    org 0x0020			;zona de programa de usuario

;Configuración inicial    
init_conf:  clrf TRISD		;RD como salidas para los segmentos del display
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) como salidas para los habilitadores del display
	    movlw 0x24
	    movwf ADCON2	;ADFM=0 (justificacion a la izquierda)
	    movlw 0x1E
	    movwf ADCON1	;AN0 habilitado
	    movlw 0x01
	    movwf ADCON0	;Seleccion de AN0 y AD encendido
	    movlw 0x04
	    movwf TBLPTRH
	    clrf TBLPTRL	;TBLPTR apunte a la direccion 0x0400
	    movlw 0x0F
	    movwf T1CON		;configuracion del Timer1
	    bcf T1CON, T1OSCEN	;opcion para desactivar el oscilador para el Proteus
	    movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L		;carga de cuenta inicial a TMR1
	    bsf PIE1, TMR1IE	;Habilitador de int de TMR1
	    bsf INTCON, PEIE	;Habilitador de int de perifericos
	    bsf INTCON, GIE	;Habilitadort global de int	    

;Rutina principal	    
loop:	    digbyte temporal	;macro para sacar los digitos de temporal
	    movff Dig2, TBLPTRL ;llamada a tabla para sacar centena
	    TBLRD*
	    movff TABLAT, LATD	;digito decena decodificado hacia RD
	    bsf LATB, 0		;habilitas digito 0 del display
	    call delay_mux	;pequeño retardo
	    bcf LATB, 0		;deshabilitas digito 0	
	    movff Dig1, TBLPTRL ;llamada a tabla para sacar decena
	    TBLRD*
	    movff TABLAT, LATD	;digito decena decodificado hacia RD
	    bsf LATB, 1		;habilitas digito 1 del display
	    call delay_mux	;pequeño retardo
	    bcf LATB, 1		;deshabilitas digito 1
	    movff Dig0, TBLPTRL ;llamada a tabla para sacar unidad
	    TBLRD*
	    movff TABLAT, LATD	;digito decena decodificado hacia RD
	    bsf LATB, 2		;habilitas digito 2 del display
	    call delay_mux	;pequeño retardo
	    bcf LATB, 2		;deshabilitas digito 2
	    movlw 0x39
	    movwf LATD		;letra C
	    bsf LATB, 3		;habilitas digito 3 del display
	    call delay_mux	;pequeño retardo
	    bcf LATB, 3		;deshabilitas digito 3
	    goto loop

;Rutina pequeño retardo
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
	    
;Rutina de interrupcion	    
TMR1_ISR:   movlw 0xC0
	    movwf TMR1H
	    clrf TMR1L		    ;carga de cuenta inicial a TMR1
	    bsf ADCON0, GO	    ;iniciamos una conversión en el A/D
otro9:	    btfsc ADCON0, DONE	    ;pregunta si ya terminó de convertir el A/D
	    goto otro9		    ;aun no termina de convertir
	    rrcf ADRESH, W	    ;muevo un bit a la derecha para obtener los 7 bits de la conversion
	    andlw 0x7F		    ;enmascarmiento para que pasen solo los 7 bits
	    movwf temporal	    ;almacenamos en registro temporal
	    bcf PIR1, TMR1IF	    ;bajamos la bandera
	    retfie		    ;retornamos de donde saltamos
	    
	    end