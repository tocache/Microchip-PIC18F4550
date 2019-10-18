    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;Libreria de nombre de los registros

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  MCLRE = ON           ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR pin disabled)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)    

i equ 0x000	;Defino una eqitqueta a la posicion 0x000 de la mem datos (RAM)

    org 0x0000			;Vector de RESET
    goto confi
    
    org 0x0020			;Zona de programa de usuario
confi:
	movlw 0xFE
	movwf TRISB		;Puerto RB0 como salida
	;bcf TRISB, 0
blinker:bsf LATB, 0		;RB0 = 1
	call delaycito		;Ejecuto un retardo (llamada a subrutina)
	bcf LATB, 0		;RB0 = 0
	call delaycito		;Ejecuto un retardo (llamada a subrutina)
	goto blinker

delaycito:
	clrf i
otro:	nop
	movlw .250
	cpfseq i
	goto aunno
	return
aunno:	incf i, f
	goto otro
	end

