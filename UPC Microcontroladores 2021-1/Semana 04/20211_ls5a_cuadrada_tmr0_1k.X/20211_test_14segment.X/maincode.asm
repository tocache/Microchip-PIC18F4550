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
    
    #define digit0 LATC, 0
    #define digit1 LATC, 1
    #define digit2 LATC, 2
    #define digit3 LATC, 6
    #define digit4 LATC, 7
    #define digit5 LATE, 0
    

posicion EQU 0x000    
var_1ms_x EQU 0x001
var_1ms_y EQU 0x002
    
    org 0x0200
mensaje_lo db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0xF7, 0x38, 0x3E, 0x36, 0x00, 0x38, 0xF7, 0x3E, 0x00, 0xBD, 0xF7, 0x36, 0x00, 0x00, 0x00, 0x00, 0x00
    org 0x0300
mensaje_hi db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00
 
    org 0x0000		;vector de reset
    goto conf_ini
    
    org 0x0008		;vector de interrupcion
    goto Tmr0_ISR
    
    org 0x0020			;zona de programa de usuario
conf_ini:   movlw 0x0F
	    movwf ADCON1	;todos los puertos en digital
	    clrf TRISD		;RD como salidas
	    movlw 0xC0
	    movwf TRISB		;RB(5:0) como salidas
	    clrf TRISC		;RC como salidas
	    bcf TRISE, 0	;RE0 como salida
	    bsf digit0
	    bsf digit1
	    bsf digit2
	    bsf digit3
	    bsf digit4
	    bsf digit5
	    movlw 0x81
	    movwf T0CON		;tomeri0 modo 16 bit, fosc/4, psc 1:8
	    movlw 0xA0
	    movwf INTCON	;interrupcion habilitada para timer0

	    clrf posicion
	    
loop:	    movff posicion, TBLPTRL
	    movlw HIGH mensaje_lo
	    movwf TBLPTRH
	    TBLRD*
	    movff TABLAT, LATD
	    movlw HIGH mensaje_hi
	    movwf TBLPTRH
	    TBLRD*+
	    movff TABLAT, LATB
	    bcf digit0		;encendemos digito0
	    call delay_1ms
	    bsf digit0		;apagamos digito0
	    movlw HIGH mensaje_lo
	    movwf TBLPTRH
	    TBLRD*
	    movff TABLAT, LATD
	    movlw HIGH mensaje_hi
	    movwf TBLPTRH
	    TBLRD*+
	    movff TABLAT, LATB
	    bcf digit1		;encendemos digito1
	    call delay_1ms
	    bsf digit1		;apagamos digito1
	    movlw HIGH mensaje_lo
	    movwf TBLPTRH
	    TBLRD*
	    movff TABLAT, LATD
	    movlw HIGH mensaje_hi
	    movwf TBLPTRH
	    TBLRD*+
	    movff TABLAT, LATB
	    bcf digit2		;encendemos digito2
	    call delay_1ms
	    bsf digit2		;apagamos digito2
	    movlw HIGH mensaje_lo
	    movwf TBLPTRH
	    TBLRD*
	    movff TABLAT, LATD
	    movlw HIGH mensaje_hi
	    movwf TBLPTRH
	    TBLRD*+
	    movff TABLAT, LATB
	    bcf digit3		;encendemos digito3
	    call delay_1ms
	    bsf digit3		;apagamos digito3
	    movlw HIGH mensaje_lo
	    movwf TBLPTRH
	    TBLRD*
	    movff TABLAT, LATD
	    movlw HIGH mensaje_hi
	    movwf TBLPTRH
	    TBLRD*+
	    movff TABLAT, LATB
	    bcf digit4		;encendemos digito4
	    call delay_1ms
	    bsf digit4		;apagamos digito4
	    movlw HIGH mensaje_lo
	    movwf TBLPTRH
	    TBLRD*
	    movff TABLAT, LATD
	    movlw HIGH mensaje_hi
	    movwf TBLPTRH
	    TBLRD*+
	    movff TABLAT, LATB
	    bcf digit5		;encendemos digito5
	    call delay_1ms
	    bsf digit5		;apagamos digito5
	    goto loop

delay_1ms: movlw .80
	    movwf var_1ms_x
aun_no1:    call anid1
	    decfsz var_1ms_x, f
	    goto aun_no1
	    return
anid1:	    movlw .12
	    movwf var_1ms_y
aun_no2:    nop
	    decfsz var_1ms_y, f
	    goto aun_no2
	    return
		
Tmr0_ISR:   movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		;Cuenta inicial de 3036 en Tmr0
	    movlw .18
	    cpfseq posicion	;pregunto si estoy en el ultimo mensaje
	    goto aunno
	    clrf posicion
	    goto otro
aunno:	    incf posicion, f
otro:	    bcf INTCON, TMR0IF	;bajamos la bandera de desborde de Tmr0    
	    retfie
	    end

		