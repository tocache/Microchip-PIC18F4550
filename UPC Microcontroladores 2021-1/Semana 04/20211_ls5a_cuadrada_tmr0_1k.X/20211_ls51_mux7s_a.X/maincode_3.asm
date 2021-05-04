;Este es un comentario
    list p=18f4550
    #include <p18f4550.inc>	;libreria de nombre de los registros sfr

    CONFIG  FOSC = XT_XT
    CONFIG  CPUDIV = OSC1_PLL2
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    CONFIG  MCLRE = ON
    
posicion EQU 0x000		;Me permitira fijar la posicion pivote en la cadena de mensaje
 
    org 0x0300
mensaje db 0x00, 0x00, 0x00, 0x00, 0x06, 0x54, 0x6F, 0x79, 0x54, 0x06, 0x79, 0x50, 0x06, 0x77, 0x00, 0x00, 0x00, 0x00
    
    org 0x0000			;vector de reset
    goto init_conf
    
    org 0x0008
    goto Tmr0_ISR
    
    org 0x0020			;zona de programa de usuario
init_conf:  movlw 0x80
	    movwf TRISD	    ;RD(6:0) como salidas
	    movlw 0xF0
	    movwf TRISB	    ;RB(3:0) como salidas
	    clrf LATB	    ;RB en cero
	    movlw HIGH mensaje
	    movwf TBLPTRH
	    movlw LOW mensaje
	    movwf TBLPTRL
	    movlw 0x81
	    movwf T0CON	    ;Tmr0 ON, fosc/4, psc 1:8, modo 16bit
	    movlw 0xA0
	    movwf INTCON    ;GIE=1, TMR0IE=1 interrupcion activo para desborde de TMR0
	    clrf posicion
	    
loop:	    movff posicion, TBLPTRL
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 0
	    call nop_group
	    bcf LATB, 0
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 1
	    call nop_group
	    bcf LATB, 1
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 2
	    call nop_group
	    bcf LATB, 2
	    TBLRD*+
	    movff TABLAT, LATD
	    bsf LATB, 3
	    call nop_group
	    bcf LATB, 3
	    goto loop
	    
nop_group:  nop
	    nop
	    nop
	    nop
	    return
	    
Tmr0_ISR:   movlw 0x0B
	    movwf TMR0H
	    movlw 0xDC
	    movwf TMR0L		;Carga de cuenta inicial a TMR0
	    movlw .14
	    cpfseq posicion	;Pregunto si ya estoy en el último cuarteto de letras del mensaje
	    goto aunno
	    clrf posicion
	    goto otro
aunno:	    incf posicion, f	;Paso al siguiente mensaje
otro:	    bcf INTCON, TMR0IF
	    retfie
	    end