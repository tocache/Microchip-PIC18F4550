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

    cblock 0x0000
    var_1ms
    endc
    
    org 0x0000		;vector de reset
    goto init_conf
    
    org 0x0020		;zona de programa de usuario
init_conf:  movlw 0x80
	    movwf TRISD		;RD(6:0) son salidas
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) son salidas
	    clrf LATB		;Los cuatro habilitadores del display en cero
loop:	    movlw b'00111001'	;Letra C
	    movwf LATD
	    bsf LATB, 0		;digito0 encendido
	    call delay_1ms
	    bcf LATB, 0		;digito0 apagado
	    movlw b'01110111'	;Letra A
	    movwf LATD
	    bsf LATB, 1		;digito1 encendido
	    call delay_1ms
	    bcf LATB, 1		;digito1 apagado
	    movlw b'01101101'	;Letra S
	    movwf LATD
	    bsf LATB, 2		;digito2 encendido
	    call delay_1ms
	    bcf LATB, 2		;digito2 apagado
	    movlw b'01110111'	;Letra A
	    movwf LATD
	    bsf LATB, 3		;digito3 encendido
	    call delay_1ms
	    bcf LATB, 3		;digito3 apagado
	    goto loop

delay_1ms:  movlw 0x90
	    movwf var_1ms
otro:	    decfsz var_1ms, f
	    goto aun_no
	    return
aun_no:	    nop
	    nop
	    goto otro
	    end
	    
    
    