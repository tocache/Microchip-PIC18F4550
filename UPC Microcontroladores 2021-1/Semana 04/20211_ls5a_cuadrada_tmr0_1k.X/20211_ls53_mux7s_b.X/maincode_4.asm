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
    posicion
    var_1ms
    endc
    
    org 0x0500
mensaje db 0x00, 0x00, 0x00, 0x00, 0x79, 0x38, 0x38, 0x77, 0x00, 0x54, 0x5c, 0x00, 0x78, 0x79, 0x00, 0x77, 0x37, 0x77, 0x00, 0x00, 0x00, 0x00
 
    org 0x0000		;vector de reset
    goto init_conf
    
    org 0x0008		;vector de interrupcion
    goto Timer0_ISR
    
    org 0x0020		;zona de programa de usuario
init_conf:  movlw 0x80
	    movwf TRISD		;RD(6:0) son salidas
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) son salidas
	    clrf LATB		;Los cuatro habilitadores del display en cero
	    movlw 0xC5
	    movwf T0CON		;TMR0 on, fosc/4, psc 1:64, modo 8 bit
	    movlw 0xA0
	    movwf INTCON	;GIE=1, TMR0IE=1 (interrupciones activadas para el desborde del TMR0)
	    movlw .126
	    movwf TMR0L		;carga de cuenta inicial al Timer0
	    movlw HIGH mensaje
	    movwf TBLPTRH
	    movlw LOW mensaje
	    movwf TBLPTRL
	    clrf posicion
   
loop:	    call delay_long
	    movlw .18
	    cpfseq posicion
	    goto todavia
	    clrf posicion
	    goto loop
todavia:    incf posicion, f
	    goto loop

Timer0_ISR: movff posicion, TBLPTRL
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 0		;digito0 encendido
	    call delay_1ms
	    bcf LATB, 0		;digito0 apagado
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 1		;digito1 encendido
	    call delay_1ms
	    bcf LATB, 1		;digito1 apagado
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 2		;digito2 encendido
	    call delay_1ms
	    bcf LATB, 2		;digito2 apagado
	    TBLRD*
	    movff TABLAT, LATD
	    bsf LATB, 3		;digito3 encendido
	    call delay_1ms
	    bcf LATB, 3		;digito3 apagado
	    bcf INTCON, TMR0IF	;bajamos la bandera del desborde del Timer0
	    retfie
	    
delay_1ms:  movlw 0x90
	    movwf var_1ms
otro:	    decfsz var_1ms, f
	    goto aun_no
	    return
aun_no:	    nop
	    nop
	    goto otro
	    
delay_long:    
    movlw .20
    movwf var_i
otro1:
    call bucle1		;Salto a subrutina
    decfsz var_i,f
    goto otro1
    return
bucle1:
    movlw .40
    movwf var_j
otro2:
    nop
    nop
    call bucle2		;Salto a subrutina
    decfsz var_j,f
    goto otro2
    return
bucle2:
    movlw .50
    movwf var_k
otro3:
    nop
    decfsz var_k,f
    goto otro3
    return   	    
    end
	    
    
    