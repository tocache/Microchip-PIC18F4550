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
    var_i
    var_j
    var_k
    endc
    
    org 0x4000
mensaje_1 db 0x76, 0x3F, 0x38, 0x77
 
    org 0x5000
mensaje_2 db 0x39, 0x3F, 0x37, 0x3F
 
 
    org 0x0000
    goto init_conf		;Vector de reset
    
    org 0x0008
    goto TMR0_ISR		;Vector de interrupcion
    
    org 0x0020
init_conf:  movlw 0x80
	    movwf TRISD		;Salidas a los segmentos del display
	    movlw 0xF0
	    movwf TRISB		;Salidas a los habilitadores del display
	    clrf LATB		;Los digitos deshabilitados
	    movlw 0xC5
	    movwf T0CON		;Tmr0 Fosc/4, psc 1:64, 8 bit mode
	    movlw 0xA0
	    movwf INTCON	;GIE=1, TMR0IE=1
	    
loop:	    movlw HIGH mensaje_1
	    movwf TBLPTRH
	    movlw LOW mensaje_1
	    movwf TBLPTRL
	    call delay_long
	    movlw HIGH mensaje_2
	    movwf TBLPTRH
	    movlw LOW mensaje_2
	    movwf TBLPTRL
	    call delay_long
	    goto loop
	    
TMR0_ISR:   clrf TBLPTRL
	    TBLRD*+	    
	    movff TABLAT, LATD
	    bsf LATB, 0		;Habilitamos digito1
	    call nopes
	    bcf LATB, 0		;Deshabilitamos digito1
	    TBLRD*+	    
	    movff TABLAT, LATD
	    bsf LATB, 1		;Habilitamos digito2
	    call nopes
	    bcf LATB, 1		;Deshabilitamos digito2
	    TBLRD*+	    
	    movff TABLAT, LATD
	    bsf LATB, 2		;Habilitamos digito3
	    call nopes
	    bcf LATB, 2		;Deshabilitamos digito3
	    TBLRD*
	    movff TABLAT, LATD
	    bsf LATB, 3		;Habilitamos digito4
	    call nopes
	    bcf LATB, 3		;Deshabilitamos digito4
	    bcf INTCON, TMR0IF	;Bajar la bandera
	    retfie
	    
nopes:	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
	    nop
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
	    
delay_long:    
    movlw .100
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    return

bucle1:
    movlw .100
    movwf var_j
otro2:
    nop
    nop
    call bucle2		;Salto a subrutina
    decfsz var_j,f
    goto otro2
    return
    
bucle2:
    movlw .20
    movwf var_k
otro3:
    nop
    decfsz var_k,f
    goto otro3
    return  
    end