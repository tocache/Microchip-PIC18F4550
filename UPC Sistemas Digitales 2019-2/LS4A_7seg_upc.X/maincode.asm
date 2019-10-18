    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Libreria de nombre de los registros

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)    

    org 0x0000			;Vector de RESET
    goto confi
    
    org 0x0020			;Zona de programa de usuario
confi:
	movlw 0x80
	movwf TRISD		;RD(6:0) como salidas
bucle:	btfss PORTB, 0
	goto falso1
	btfss PORTB, 1
	goto falso2
	clrf LATD		;RB0=1, RB1=1
	goto bucle
falso2:	movlw 0x39		;RB0=1, RB1=0
	movwf LATD
	goto bucle
falso1:	btfss PORTB, 1
	goto falso3
	movlw 0x73		;RB0=0, RB1=1
	movwf LATD
	goto bucle
falso3:	movlw 0x3E		;RB0=0, RB0=0
	movwf LATD
	goto bucle
	end
	
	


