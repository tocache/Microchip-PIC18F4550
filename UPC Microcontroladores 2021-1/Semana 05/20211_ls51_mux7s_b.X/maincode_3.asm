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
    
    org 0x0200
;mensaje_1 db 0x37, 0x79, 0x39, 0x77	;palabra MECA
mensaje1 db 0x79, 0x38, 0x79, 0x39	;palabra ELEC
    org 0x0300
mensaje_2 db 0x78, 0x50, 0x5C, 0x54	;palabra TRON
 
    org 0x0400
mensaje_3 db 0x06, 0x39, 0x77, 0x00	;palabra ICA
 
    org 0x0000		;vector de reset
    goto init_conf
    
    org 0x0008		;vector de interrupcion
    goto Tmr0_ISR
    
    org 0x0020		;zona de programa de usuario
init_conf:  movlw 0x80
	    movwf TRISD		;RD(6:0) como salidas - a los segmentos
	    movlw 0xF0
	    movwf TRISB		;RB(3:0) como salidas - a los habilitadores
	    clrf LATB		;Cond. inicial de los habilitadores
	    movlw 0x02
	    movwf TBLPTRH
	    movlw 0x00
	    movwf TBLPTRL	    ;TBLPTR esta apuntando a 0x0200
	    movlw 0x82
	    movwf T0CON		    ;Timer0 fosc/4, psc 1:8 modo 16 bit
	    movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		    ;Carga inicial de cuenta (3036) a TMR0
	    movlw 0xA0
	    movwf INTCON	    ;interrupcion habilitada para Timer0
	    
loop:	    clrf TBLPTRL
	    TBLRD*+		    ;Lectura de TBLPTR e incremento
	    movff TABLAT, LATD
	    bsf LATB, 0		    ; habilitamos digito 0
	    bcf LATB, 0		    ;deshabilitamos digito 0
	    TBLRD*+		    ;Lectura de TBLPTR e incremento
	    movff TABLAT, LATD
	    bsf LATB, 1		    ; habilitamos digito 1
	    bcf LATB, 1		    ;deshabilitamos digito 1
	    TBLRD*+		    ;Lectura de TBLPTR e incremento
	    movff TABLAT, LATD
	    bsf LATB, 2		    ; habilitamos digito 2
	    bcf LATB, 2		    ;deshabilitamos digito 2
	    TBLRD*+		    ;Lectura de TBLPTR e incremento
	    movff TABLAT, LATD
	    bsf LATB, 3		    ; habilitamos digito 3
	    bcf LATB, 3		    ;deshabilitamos digito 3
	    goto loop
	    
Tmr0_ISR:   movlw 0x04
	    cpfseq TBLPTRH	    ;pregunto si estoy en el ultimo mensaje
	    goto aunno
	    movlw 0x02
	    movwf TBLPTRH	    ;regresa a visualizar al primer mensaje
	    goto otro
aunno:	    incf TBLPTRH, f	    
otro:	    movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		    ;Carga inicial de cuenta (3036) a TMR0
	    bcf INTCON, TMR0IF	    ;Bajamos la bandera de desborde del TMR0
	    retfie
	    end