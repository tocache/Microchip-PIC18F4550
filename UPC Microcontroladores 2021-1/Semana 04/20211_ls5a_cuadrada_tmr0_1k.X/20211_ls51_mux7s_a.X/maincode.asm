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
    
    org 0x0300
;mensaje db 0x76, 0x3F, 0x38, 0x77   ;HOLA    
;mensaje db 0x78, 0x79, 0x38, 0x77   ;tela    
mensaje db b'01111100', b'00000110', b'00111001', 0x77
    
    org 0x0000			;vector de reset
    goto init_conf
    
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
	    
loop:	    clrf TBLPTRL
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
	    
	    end