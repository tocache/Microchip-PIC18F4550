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
    goto canguro
    
    org 0x0020			;Zona de programa de usuario
canguro:
	movlw 0x80
	movwf TRISD		;RD(6:0) como salidas
bucle:
	movlw 0x77
	movwf LATD
	end

